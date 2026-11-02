// Standalone application window for the reusable Dashboard QML module.

import QtQuick
import Dashboard

Window {
    width: 1400
    height: 900
    minimumWidth: 1100
    minimumHeight: 700
    visible: true
    title: "Modern Dashboard - Qt QML"
    color: Theme.background

    DashboardView {
        anchors.fill: parent
    }
}
