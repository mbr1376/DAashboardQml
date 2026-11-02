import QtQuick
import Dashboard

Window {
    width: 1400
    height: 900
    minimumWidth: 1100
    minimumHeight: 700
    visible: true
    title: "Dashboard Module - Example"
    color: Theme.background

    DashboardView {
        id: dashboard
        anchors.fill: parent
        dataModel: dashboardModel

        onSaveLayoutRequested: function(layout) {
            appSettings.saveLayout(layout);
        }

        Component.onCompleted: {
            if (appSettings.hasSavedLayout)
                setLayout(appSettings.savedLayout);
        }
    }
}
