#pragma once

#include <QAbstractListModel>
#include <QMetaType>
#include <QVariantList>
#include <QVariantMap>
#include <qqmlregistration.h>

#if defined(DASHBOARDPLUGIN_LIBRARY)
#define DASHBOARD_EXPORT Q_DECL_EXPORT
#else
#define DASHBOARD_EXPORT Q_DECL_IMPORT
#endif

class DASHBOARD_EXPORT DashboardDataModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QVariantList rows READ rows NOTIFY rowsChanged)

public:
    explicit DashboardDataModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const;
    QVariantList rows() const;
    Q_INVOKABLE QVariantMap rowAt(int row) const;

    Q_INVOKABLE bool setRows(const QVariantList &rows);
    Q_INVOKABLE int appendRow(const QVariantMap &row);
    Q_INVOKABLE bool updateRow(int row, const QVariantMap &values);
    Q_INVOKABLE bool removeRow(int row);
    Q_INVOKABLE void clear();

signals:
    void countChanged();
    void rowsChanged();

private:
    bool hasValidRows(const QVariantList &rows) const;
    void rebuildRoles();

    QVariantList m_rows;
    QHash<int, QByteArray> m_roles;
};
