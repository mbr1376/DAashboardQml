#include "dashboarddatasource.h"

#include <QFile>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>

namespace {

bool rowsFromDocument(const QJsonDocument &document, QVariantList *rows, QString *error)
{
    QJsonArray array;
    if (document.isArray()) {
        array = document.array();
    } else if (document.isObject()) {
        const QJsonObject object = document.object();
        const QJsonValue value = object.contains("data") ? object.value("data")
                                                          : object.value("rows");
        if (!value.isArray()) {
            *error = QStringLiteral("JSON must contain an array or a 'data'/'rows' array.");
            return false;
        }
        array = value.toArray();
    } else {
        *error = QStringLiteral("JSON root must be an array or an object containing rows.");
        return false;
    }

    for (const QJsonValue &value : array) {
        if (!value.isObject()) {
            *error = QStringLiteral("Every data row in JSON must be an object.");
            return false;
        }
        rows->append(value.toObject().toVariantMap());
    }
    return true;
}

QVariant csvValue(const QString &value)
{
    const QString trimmed = value.trimmed();
    if (trimmed.compare(QStringLiteral("true"), Qt::CaseInsensitive) == 0)
        return true;
    if (trimmed.compare(QStringLiteral("false"), Qt::CaseInsensitive) == 0)
        return false;
    bool ok = false;
    const double number = trimmed.toDouble(&ok);
    if (ok && !trimmed.isEmpty())
        return number;
    return value;
}

} // namespace

DashboardDataSource::DashboardDataSource(QObject *parent)
    : QObject(parent)
{
}

QVariantList DashboardDataSource::rows() const
{
    return m_rows;
}

QString DashboardDataSource::errorMessage() const
{
    return m_errorMessage;
}

bool DashboardDataSource::loading() const
{
    return m_loading;
}

bool DashboardDataSource::setRows(const QVariantList &rows)
{
    for (const QVariant &row : rows) {
        if (row.metaType().id() != QMetaType::QVariantMap
            && row.metaType().id() != QMetaType::QJsonObject) {
            return setError(QStringLiteral("Each data row must be an object with named fields."));
        }
    }

    disconnectSourceModel();
    if (m_rows != rows) {
        m_rows.clear();
        m_rows.reserve(rows.size());
        for (const QVariant &row : rows) {
            m_rows.append(row.metaType().id() == QMetaType::QJsonObject
                              ? row.toJsonObject().toVariantMap()
                              : row.toMap());
        }
        emit rowsChanged();
    }
    if (!m_errorMessage.isEmpty()) {
        m_errorMessage.clear();
        emit errorMessageChanged();
    }
    return true;
}

bool DashboardDataSource::setSource(QObject *source)
{
    auto *model = qobject_cast<QAbstractItemModel *>(source);
    if (source && !model)
        return setError(QStringLiteral("The data source must be a Qt item model."));

    disconnectSourceModel();
    m_sourceModel = model;
    if (!model) {
        if (!m_rows.isEmpty()) {
            m_rows.clear();
            emit rowsChanged();
        }
        if (!m_errorMessage.isEmpty()) {
            m_errorMessage.clear();
            emit errorMessageChanged();
        }
        return true;
    }

    const auto refresh = [this]() { refreshModel(); };
    m_sourceConnections.append(connect(model, &QAbstractItemModel::modelReset, this, refresh));
    m_sourceConnections.append(connect(model, &QAbstractItemModel::rowsInserted, this, refresh));
    m_sourceConnections.append(connect(model, &QAbstractItemModel::rowsRemoved, this, refresh));
    m_sourceConnections.append(connect(model, &QAbstractItemModel::rowsMoved, this, refresh));
    m_sourceConnections.append(connect(model, &QAbstractItemModel::dataChanged, this, refresh));
    m_sourceConnections.append(connect(model, &QAbstractItemModel::layoutChanged, this, refresh));
    m_sourceConnections.append(connect(model, &QObject::destroyed, this, [this]() {
        m_sourceModel = nullptr;
        m_sourceConnections.clear();
        m_rows.clear();
        emit rowsChanged();
    }));
    refreshModel();
    return true;
}

bool DashboardDataSource::loadJson(const QString &json)
{
    return setRowsFromJson(json.toUtf8());
}

bool DashboardDataSource::loadCsv(const QString &csv)
{
    if (csv.isEmpty())
        return setError(QStringLiteral("CSV data is empty."));

    QList<QStringList> records;
    QStringList record;
    QString field;
    bool quoted = false;
    const QString text = csv;
    for (qsizetype i = 0; i < text.size(); ++i) {
        const QChar ch = text.at(i);
        if (quoted) {
            if (ch == QLatin1Char('"')) {
                if (i + 1 < text.size() && text.at(i + 1) == QLatin1Char('"')) {
                    field.append(QLatin1Char('"'));
                    ++i;
                } else {
                    quoted = false;
                }
            } else {
                field.append(ch);
            }
        } else if (ch == QLatin1Char('"') && field.isEmpty()) {
            quoted = true;
        } else if (ch == QLatin1Char(',')) {
            record.append(field);
            field.clear();
        } else if (ch == QLatin1Char('\n') || ch == QLatin1Char('\r')) {
            if (ch == QLatin1Char('\r') && i + 1 < text.size()
                && text.at(i + 1) == QLatin1Char('\n')) {
                ++i;
            }
            record.append(field);
            field.clear();
            if (!(record.size() == 1 && record.first().isEmpty()))
                records.append(record);
            record.clear();
        } else {
            field.append(ch);
        }
    }
    if (quoted)
        return setError(QStringLiteral("CSV contains an unterminated quoted field."));

    if (!field.isEmpty() || !record.isEmpty()) {
        record.append(field);
        records.append(record);
    }
    if (records.size() < 2)
        return setError(QStringLiteral("CSV must contain a header and at least one data row."));

    QStringList headers = records.first();
    for (qsizetype i = 0; i < headers.size(); ++i) {
        headers[i] = headers[i].trimmed();
        if (headers[i].isEmpty())
            headers[i] = QStringLiteral("column_%1").arg(i + 1);
    }

    QVariantList parsedRows;
    for (qsizetype rowIndex = 1; rowIndex < records.size(); ++rowIndex) {
        QVariantMap row;
        for (qsizetype column = 0; column < headers.size(); ++column) {
            const QString value = column < records[rowIndex].size()
                ? records[rowIndex].at(column) : QString();
            row.insert(headers.at(column), csvValue(value));
        }
        parsedRows.append(row);
    }
    return setRows(parsedRows);
}

bool DashboardDataSource::loadFile(const QUrl &url)
{
    const QString path = url.isLocalFile() ? url.toLocalFile() : QString();
    if (path.isEmpty())
        return setError(QStringLiteral("Only local JSON and CSV files can be opened."));

    QFile file(path);
    if (!file.open(QIODevice::ReadOnly))
        return setError(QStringLiteral("Cannot open file: %1").arg(file.errorString()));

    const QByteArray contents = file.readAll();
    if (QFileInfo(path).suffix().compare(QStringLiteral("csv"), Qt::CaseInsensitive) == 0)
        return loadCsv(QString::fromUtf8(contents));
    return setRowsFromJson(contents);
}

bool DashboardDataSource::loadUrl(const QUrl &url, const QString &bearerToken)
{
    if (!url.isValid() || (url.scheme() != QStringLiteral("http")
                           && url.scheme() != QStringLiteral("https"))) {
        return setError(QStringLiteral("Enter a valid HTTP or HTTPS API URL."));
    }

    if (m_reply) {
        const QPointer<QNetworkReply> previous = m_reply;
        m_reply = nullptr;
        previous->abort();
    }

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("DashboardQML/1.0"));
    if (!bearerToken.trimmed().isEmpty()) {
        request.setRawHeader("Authorization", QByteArray("Bearer ") + bearerToken.toUtf8());
    }
    QNetworkReply *reply = m_network.get(request);
    m_reply = reply;
    setLoading(true);
    if (!m_errorMessage.isEmpty()) {
        m_errorMessage.clear();
        emit errorMessageChanged();
    }

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (m_reply != reply) {
            reply->deleteLater();
            return;
        }
        m_reply = nullptr;
        setLoading(false);

        const int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (reply->error() != QNetworkReply::NoError) {
            setError(QStringLiteral("API request failed: %1").arg(reply->errorString()));
        } else if (statusCode >= 400) {
            setError(QStringLiteral("API returned HTTP %1.").arg(statusCode));
        } else {
            setRowsFromJson(reply->readAll());
        }
        reply->deleteLater();
    });
    return true;
}

bool DashboardDataSource::setRowsFromJson(const QByteArray &json)
{
    QJsonParseError parseError;
    const QJsonDocument document = QJsonDocument::fromJson(json, &parseError);
    if (parseError.error != QJsonParseError::NoError)
        return setError(QStringLiteral("Invalid JSON: %1").arg(parseError.errorString()));

    QVariantList parsedRows;
    QString error;
    if (!rowsFromDocument(document, &parsedRows, &error))
        return setError(error);
    return setRows(parsedRows);
}

bool DashboardDataSource::setError(const QString &message)
{
    if (m_errorMessage != message) {
        m_errorMessage = message;
        emit errorMessageChanged();
    }
    return false;
}

void DashboardDataSource::setLoading(bool loading)
{
    if (m_loading == loading)
        return;
    m_loading = loading;
    emit loadingChanged();
}

void DashboardDataSource::refreshModel()
{
    if (!m_sourceModel)
        return;

    QVariantList rows;
    const QHash<int, QByteArray> roles = m_sourceModel->roleNames();
    for (int row = 0; row < m_sourceModel->rowCount(); ++row) {
        QVariantMap values;
        const QModelIndex index = m_sourceModel->index(row, 0);
        if (roles.isEmpty()) {
            values.insert(QStringLiteral("value"), m_sourceModel->data(index, Qt::DisplayRole));
        } else {
            for (auto role = roles.cbegin(); role != roles.cend(); ++role) {
                values.insert(QString::fromUtf8(role.value()),
                              m_sourceModel->data(index, role.key()));
            }
        }
        rows.append(values);
    }
    if (m_rows != rows) {
        m_rows = rows;
        emit rowsChanged();
    }
    if (!m_errorMessage.isEmpty()) {
        m_errorMessage.clear();
        emit errorMessageChanged();
    }
}

void DashboardDataSource::disconnectSourceModel()
{
    for (const QMetaObject::Connection &connection : std::as_const(m_sourceConnections))
        disconnect(connection);
    m_sourceConnections.clear();
    m_sourceModel = nullptr;
}
