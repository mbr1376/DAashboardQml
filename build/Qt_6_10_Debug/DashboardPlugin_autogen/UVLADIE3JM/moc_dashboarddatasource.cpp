/****************************************************************************
** Meta object code from reading C++ file 'dashboarddatasource.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/dashboarddatasource.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'dashboarddatasource.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.10.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN19DashboardDataSourceE_t {};
} // unnamed namespace

template <> constexpr inline auto DashboardDataSource::qt_create_metaobjectdata<qt_meta_tag_ZN19DashboardDataSourceE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "DashboardDataSource",
        "QML.Element",
        "auto",
        "rowsChanged",
        "",
        "errorMessageChanged",
        "loadingChanged",
        "setRows",
        "QVariantList",
        "rows",
        "setSource",
        "source",
        "loadJson",
        "json",
        "loadCsv",
        "csv",
        "loadFile",
        "QUrl",
        "url",
        "loadUrl",
        "bearerToken",
        "errorMessage",
        "loading"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'rowsChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'errorMessageChanged'
        QtMocHelpers::SignalData<void()>(5, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'loadingChanged'
        QtMocHelpers::SignalData<void()>(6, 4, QMC::AccessPublic, QMetaType::Void),
        // Method 'setRows'
        QtMocHelpers::MethodData<bool(const QVariantList &)>(7, 4, QMC::AccessPublic, QMetaType::Bool, {{
            { 0x80000000 | 8, 9 },
        }}),
        // Method 'setSource'
        QtMocHelpers::MethodData<bool(QObject *)>(10, 4, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::QObjectStar, 11 },
        }}),
        // Method 'loadJson'
        QtMocHelpers::MethodData<bool(const QString &)>(12, 4, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::QString, 13 },
        }}),
        // Method 'loadCsv'
        QtMocHelpers::MethodData<bool(const QString &)>(14, 4, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::QString, 15 },
        }}),
        // Method 'loadFile'
        QtMocHelpers::MethodData<bool(const QUrl &)>(16, 4, QMC::AccessPublic, QMetaType::Bool, {{
            { 0x80000000 | 17, 18 },
        }}),
        // Method 'loadUrl'
        QtMocHelpers::MethodData<bool(const QUrl &, const QString &)>(19, 4, QMC::AccessPublic, QMetaType::Bool, {{
            { 0x80000000 | 17, 18 }, { QMetaType::QString, 20 },
        }}),
        // Method 'loadUrl'
        QtMocHelpers::MethodData<bool(const QUrl &)>(19, 4, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Bool, {{
            { 0x80000000 | 17, 18 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'rows'
        QtMocHelpers::PropertyData<QVariantList>(9, 0x80000000 | 8, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'errorMessage'
        QtMocHelpers::PropertyData<QString>(21, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'loading'
        QtMocHelpers::PropertyData<bool>(22, QMetaType::Bool, QMC::DefaultPropertyFlags, 2),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<DashboardDataSource, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject DashboardDataSource::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19DashboardDataSourceE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19DashboardDataSourceE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN19DashboardDataSourceE_t>.metaTypes,
    nullptr
} };

void DashboardDataSource::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<DashboardDataSource *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->rowsChanged(); break;
        case 1: _t->errorMessageChanged(); break;
        case 2: _t->loadingChanged(); break;
        case 3: { bool _r = _t->setRows((*reinterpret_cast<std::add_pointer_t<QVariantList>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 4: { bool _r = _t->setSource((*reinterpret_cast<std::add_pointer_t<QObject*>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 5: { bool _r = _t->loadJson((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 6: { bool _r = _t->loadCsv((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 7: { bool _r = _t->loadFile((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 8: { bool _r = _t->loadUrl((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 9: { bool _r = _t->loadUrl((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (DashboardDataSource::*)()>(_a, &DashboardDataSource::rowsChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (DashboardDataSource::*)()>(_a, &DashboardDataSource::errorMessageChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (DashboardDataSource::*)()>(_a, &DashboardDataSource::loadingChanged, 2))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->rows(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->errorMessage(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->loading(); break;
        default: break;
        }
    }
}

const QMetaObject *DashboardDataSource::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *DashboardDataSource::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19DashboardDataSourceE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int DashboardDataSource::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 10)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 10)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 10;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void DashboardDataSource::rowsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void DashboardDataSource::errorMessageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void DashboardDataSource::loadingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}
QT_WARNING_POP
