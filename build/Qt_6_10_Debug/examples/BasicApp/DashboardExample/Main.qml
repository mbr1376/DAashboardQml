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

    ListModel {
        id: sampleModel

        ListElement { category: "Online"; sales: 240; orders: 120; expenses: 72 }
        ListElement { category: "Retail"; sales: 185; orders: 94; expenses: 63 }
        ListElement { category: "Wholesale"; sales: 310; orders: 61; expenses: 110 }
        ListElement { category: "Partner"; sales: 155; orders: 48; expenses: 52 }
        ListElement { category: "Mobile"; sales: 205; orders: 108; expenses: 70 }
        ListElement { category: "Other"; sales: 95; orders: 39; expenses: 33 }
    }

    DashboardView {
        id: dashboard
        anchors.fill: parent
        dataModel: sampleModel

        onSaveLayoutRequested: function(layout) {
            appSettings.saveLayout(layout);
        }

        Component.onCompleted: {
            if (appSettings.hasSavedLayout)
                setLayout(appSettings.savedLayout);
        }
    }
}
