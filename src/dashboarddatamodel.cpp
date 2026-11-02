#include "dashboard/dashboarddatamodel.h"

#include <QJsonObject>
#include <QSet>
#include <algorithm>

DashboardDataModel::DashboardDataModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int DashboardDataModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_rows.size();
}

QVariant DashboardDataModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_rows.size())
        return {};

    const QByteArray roleName = m_roles.value(role);
    if (roleName.isEmpty())
        return {};
    return m_rows.at(index.row()).toMap().value(QString::fromUtf8(roleName));
}

QHash<int, QByteArray> DashboardDataModel::roleNames() const
{
    return m_roles;
}

int DashboardDataModel::count() const
{
    return m_rows.size();
}

QVariantList DashboardDataModel::rows() const
{
    return m_rows;
}

QVariantMap DashboardDataModel::rowAt(int row) const
{
    if (row < 0 || row >= m_rows.size())
        return {};
    return m_rows.at(row).toMap();
}

bool DashboardDataModel::setRows(const QVariantList &rows)
{
    if (!hasValidRows(rows))
        return false;

    const int oldCount = m_rows.size();
    beginResetModel();
    m_rows.clear();
    m_rows.reserve(rows.size());
    for (const QVariant &value : rows) {
        m_rows.append(value.metaType().id() == QMetaType::QJsonObject
                          ? value.toJsonObject().toVariantMap() : value.toMap());
    }
    rebuildRoles();
    endResetModel();
    emit rowsChanged();
    if (oldCount != m_rows.size())
        emit countChanged();
    return true;
}

int DashboardDataModel::appendRow(const QVariantMap &row)
{
    if (row.isEmpty())
        return -1;

    const int rowIndex = m_rows.size();
    QSet<QByteArray> newRoleNames;
    for (auto it = row.cbegin(); it != row.cend(); ++it) {
        const QByteArray name = it.key().toUtf8();
        if (name.isEmpty())
            return -1;
        if (!m_roles.values().contains(name))
            newRoleNames.insert(name);
    }

    if (!newRoleNames.isEmpty()) {
        beginResetModel();
        m_rows.append(row);
        rebuildRoles();
        endResetModel();
        emit rowsChanged();
        emit countChanged();
        return rowIndex;
    }

    beginInsertRows(QModelIndex(), rowIndex, rowIndex);
    m_rows.append(row);
    endInsertRows();
    emit rowsChanged();
    emit countChanged();
    return rowIndex;
}

bool DashboardDataModel::updateRow(int row, const QVariantMap &values)
{
    if (row < 0 || row >= m_rows.size() || values.isEmpty())
        return false;

    QVariantMap updated = m_rows.at(row).toMap();
    for (auto it = values.cbegin(); it != values.cend(); ++it) {
        if (it.key().isEmpty())
            return false;
        updated.insert(it.key(), it.value());
    }

    for (auto it = values.cbegin(); it != values.cend(); ++it) {
        const QByteArray name = it.key().toUtf8();
        if (!m_roles.values().contains(name)) {
            beginResetModel();
            m_rows[row] = updated;
            rebuildRoles();
            endResetModel();
            emit rowsChanged();
            return true;
        }
    }

    m_rows[row] = updated;
    const QModelIndex changedIndex = index(row, 0);
    emit dataChanged(changedIndex, changedIndex);
    emit rowsChanged();
    return true;
}

bool DashboardDataModel::removeRow(int row)
{
    if (row < 0 || row >= m_rows.size())
        return false;

    beginRemoveRows(QModelIndex(), row, row);
    m_rows.removeAt(row);
    endRemoveRows();
    emit rowsChanged();
    emit countChanged();
    return true;
}

void DashboardDataModel::clear()
{
    if (m_rows.isEmpty())
        return;

    beginResetModel();
    m_rows.clear();
    rebuildRoles();
    endResetModel();
    emit rowsChanged();
    emit countChanged();
}

bool DashboardDataModel::hasValidRows(const QVariantList &rows) const
{
    for (const QVariant &value : rows) {
        const int type = value.metaType().id();
        if (type != QMetaType::QVariantMap && type != QMetaType::QJsonObject)
            return false;

        const QVariantMap row = type == QMetaType::QJsonObject
            ? value.toJsonObject().toVariantMap() : value.toMap();
        for (auto it = row.cbegin(); it != row.cend(); ++it) {
            if (it.key().isEmpty())
                return false;
        }
    }
    return true;
}

void DashboardDataModel::rebuildRoles()
{
    QSet<QByteArray> names;
    for (const QVariant &value : m_rows) {
        const QVariantMap row = value.metaType().id() == QMetaType::QJsonObject
            ? value.toJsonObject().toVariantMap() : value.toMap();
        for (auto it = row.cbegin(); it != row.cend(); ++it) {
            const QByteArray name = it.key().toUtf8();
            if (!name.isEmpty())
                names.insert(name);
        }
    }

    QList<QByteArray> sortedNames = names.values();
    std::sort(sortedNames.begin(), sortedNames.end());
    m_roles.clear();
    int role = Qt::UserRole + 1;
    for (const QByteArray &name : sortedNames)
        m_roles.insert(role++, name);
}
