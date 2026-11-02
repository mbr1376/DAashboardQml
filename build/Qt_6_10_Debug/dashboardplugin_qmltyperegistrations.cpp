/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#if __has_include(<dashboarddatamodel.h>)
#  include <dashboarddatamodel.h>
#endif
#if __has_include(<dashboarddatasource.h>)
#  include <dashboarddatasource.h>
#endif
#if __has_include(<donuttchartitem.h>)
#  include <donuttchartitem.h>
#endif
#if __has_include(<linechartitem.h>)
#  include <linechartitem.h>
#endif


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_Dashboard()
{
    QT_WARNING_PUSH QT_WARNING_DISABLE_DEPRECATED
    qmlRegisterTypesAndRevisions<DashboardDataModel>("Dashboard", 1);
    qmlRegisterTypesAndRevisions<DashboardDataSource>("Dashboard", 1);
    qmlRegisterTypesAndRevisions<DonutChartItem>("Dashboard", 1);
    qmlRegisterAnonymousType<QQuickItem, 254>("Dashboard", 1);
    qmlRegisterTypesAndRevisions<LineChartItem>("Dashboard", 1);
    QMetaType::fromType<QAbstractItemModel *>().id();
    qmlRegisterEnum<QAbstractItemModel::LayoutChangeHint>("QAbstractItemModel::LayoutChangeHint");
    qmlRegisterEnum<QAbstractItemModel::CheckIndexOption>("QAbstractItemModel::CheckIndexOption");
    QMetaType::fromType<QAbstractListModel *>().id();
    QT_WARNING_POP
    qmlRegisterModule("Dashboard", 1, 0);
}

static const QQmlModuleRegistration dashboardRegistration("Dashboard", qml_register_types_Dashboard);
