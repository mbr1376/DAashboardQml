#pragma once

#include <QAbstractItemModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QPointer>
#include <QVariantList>
#include <QUrl>
#include <QObject>
#include <qqmlregistration.h>

class DashboardDataSource : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QVariantList rows READ rows NOTIFY rowsChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit DashboardDataSource(QObject *parent = nullptr);

    QVariantList rows() const;
    QString errorMessage() const;
    bool loading() const;

    Q_INVOKABLE bool setRows(const QVariantList &rows);
    Q_INVOKABLE bool setSource(QObject *source);
    Q_INVOKABLE bool loadJson(const QString &json);
    Q_INVOKABLE bool loadCsv(const QString &csv);
    Q_INVOKABLE bool loadFile(const QUrl &url);
    Q_INVOKABLE bool loadUrl(const QUrl &url, const QString &bearerToken = {});

signals:
    void rowsChanged();
    void errorMessageChanged();
    void loadingChanged();

private:
    bool setRowsFromJson(const QByteArray &json);
    bool setError(const QString &message);
    void setLoading(bool loading);
    void refreshModel();
    void disconnectSourceModel();

    QVariantList m_rows;
    QString m_errorMessage;
    bool m_loading = false;
    QNetworkAccessManager m_network;
    QPointer<QNetworkReply> m_reply;
    QPointer<QAbstractItemModel> m_sourceModel;
    QList<QMetaObject::Connection> m_sourceConnections;
};
