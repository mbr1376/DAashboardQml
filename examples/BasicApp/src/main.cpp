#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSettings>
#include <dashboard/dashboarddatamodel.h>

class DashboardExampleSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList savedLayout READ savedLayout CONSTANT)
    Q_PROPERTY(bool hasSavedLayout READ hasSavedLayout CONSTANT)

public:
    explicit DashboardExampleSettings(QObject *parent = nullptr)
        : QObject(parent)
        , m_savedLayout(QSettings().value(QStringLiteral("dashboard/layout")).toList())
    {
    }

    QVariantList savedLayout() const { return m_savedLayout; }
    bool hasSavedLayout() const { return !m_savedLayout.isEmpty(); }

    Q_INVOKABLE void saveLayout(const QVariantList &layout)
    {
        QSettings().setValue(QStringLiteral("dashboard/layout"), layout);
        m_savedLayout = layout;
    }

private:
    QVariantList m_savedLayout;
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName(QStringLiteral("LearnQt"));
    app.setApplicationName(QStringLiteral("DashboardExample"));
    QQuickStyle::setStyle("Basic");

    DashboardExampleSettings settings;
    DashboardDataModel dashboardModel;
    dashboardModel.setRows({
        QVariantMap{{QStringLiteral("category"), QStringLiteral("Online")},
                    {QStringLiteral("sales"), 240}, {QStringLiteral("orders"), 120},
                    {QStringLiteral("expenses"), 72}},
        QVariantMap{{QStringLiteral("category"), QStringLiteral("Retail")},
                    {QStringLiteral("sales"), 185}, {QStringLiteral("orders"), 94},
                    {QStringLiteral("expenses"), 63}},
        QVariantMap{{QStringLiteral("category"), QStringLiteral("Wholesale")},
                    {QStringLiteral("sales"), 310}, {QStringLiteral("orders"), 61},
                    {QStringLiteral("expenses"), 110}},
        QVariantMap{{QStringLiteral("category"), QStringLiteral("Partner")},
                    {QStringLiteral("sales"), 155}, {QStringLiteral("orders"), 48},
                    {QStringLiteral("expenses"), 52}},
        QVariantMap{{QStringLiteral("category"), QStringLiteral("Mobile")},
                    {QStringLiteral("sales"), 205}, {QStringLiteral("orders"), 108},
                    {QStringLiteral("expenses"), 70}},
        QVariantMap{{QStringLiteral("category"), QStringLiteral("Other")},
                    {QStringLiteral("sales"), 95}, {QStringLiteral("orders"), 39},
                    {QStringLiteral("expenses"), 33}}
    });

    QQmlApplicationEngine engine;
    engine.addImportPath(QStringLiteral(DASHBOARD_QML_IMPORT_PATH));
    engine.rootContext()->setContextProperty(QStringLiteral("appSettings"), &settings);
    engine.rootContext()->setContextProperty(QStringLiteral("dashboardModel"), &dashboardModel);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("DashboardExample", "Main");

    return app.exec();
}

#include "main.moc"
