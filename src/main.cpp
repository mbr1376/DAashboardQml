// main.cpp - Application entry point for the QML Dashboard
//
// This file sets up the QML application, registers custom C++ chart
// types for QML to use, and loads the main QML file.
//
// Qt concepts demonstrated:
//   - QGuiApplication (QML does not need full QApplication)
//   - QQmlApplicationEngine for loading QML
//   - Registering custom C++ QQuickPaintedItem types for QML

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QFont>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Set application metadata
    app.setApplicationName("DashboardApp");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("LearnQt");

    // ============================================================
    // 🔤 EASY FONT CUSTOMIZATION: Choose Your Typography!
    // ============================================================
    // Uncomment ONE of the font configurations below.
    // Each provides a different look and feel for the entire dashboard.
    // ============================================================

    // === OPTION 1: Segoe UI (Windows Default — Modern & Clean) ===
    // QFont appFont("Segoe UI", 13);
    // appFont.setStyleStrategy(QFont::PreferAntialias);
    // app.setFont(appFont);

    // === OPTION 2: Inter (Web-Inspired — Crisp & Professional) ===
    // Great for dashboards and data-heavy interfaces
    // QFont appFont("Inter", 12);
    // appFont.setStyleStrategy(QFont::PreferAntialias);
    // app.setFont(appFont);

    // === OPTION 3: Roboto (Google Material — Friendly & Legible) ===
    // Popular in Android/Material Design apps
    // QFont appFont("Roboto", 12);
    // appFont.setStyleStrategy(QFont::PreferAntialias);
    // app.setFont(appFont);

    // === OPTION 4: SF Pro Text (Apple-Style — Elegant & Refined) ===
    // Works great on all platforms if SF Pro is installed
    // QFont appFont("SF Pro Text", 12);
    // appFont.setStyleStrategy(QFont::PreferAntialias);
    // app.setFont(appFont);

    // === OPTION 5: Helvetica Neue (Classic — Timeless & Neutral) ===
    // Traditional choice for professional applications
    QFont appFont("Helvetica Neue", 12);
    appFont.setStyleStrategy(QFont::PreferAntialias);
    app.setFont(appFont);

    // === OPTION 6: Poppins (Modern & Geometric — Bold & Trendy) ===
    // Great for vibrant, contemporary designs
    // QFont appFont("Poppins", 12);
    // appFont.setStyleStrategy(QFont::PreferAntialias);
    // app.setFont(appFont);

    // === OPTION 7: JetBrains Mono (Monospace — Developer-Focused) ===
    // Ideal for technical/developer dashboards
    // QFont appFont("JetBrains Mono", 11);
    // appFont.setStyleStrategy(QFont::PreferAntialias);
    // app.setFont(appFont);

    // Use Basic style for a clean, customizable look
    QQuickStyle::setStyle("Basic");

    // Chart types (LineChartItem, DonutChartItem) are registered automatically
    // via QML_ELEMENT in their headers + SOURCES in qt_add_qml_module.

    QQmlApplicationEngine engine;
    engine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("DashboardApp", "Main");

    return app.exec();
}
