#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSettings>

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

    QQmlApplicationEngine engine;
    engine.addImportPath(QStringLiteral(DASHBOARD_QML_IMPORT_PATH));
    DashboardExampleSettings settings;
    engine.rootContext()->setContextProperty(QStringLiteral("appSettings"), &settings);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("DashboardExample", "Main");

    return app.exec();
}

#include "main.moc"
