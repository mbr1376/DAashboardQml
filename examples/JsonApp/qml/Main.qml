import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Dashboard

Window {
    width: 1400
    height: 900
    minimumWidth: 1000
    minimumHeight: 700
    visible: true
    title: "Dashboard - JSON data example"
    color: Theme.background

    property string sampleJson: "[\n" +
        "  { \"category\": \"Online\", \"sales\": 240, \"orders\": 120, \"expenses\": 72 },\n" +
        "  { \"category\": \"Retail\", \"sales\": 185, \"orders\": 94, \"expenses\": 63 },\n" +
        "  { \"category\": \"Wholesale\", \"sales\": 310, \"orders\": 61, \"expenses\": 110 },\n" +
        "  { \"category\": \"Partner\", \"sales\": 155, \"orders\": 48, \"expenses\": 52 },\n" +
        "  { \"category\": \"Mobile\", \"sales\": 205, \"orders\": 108, \"expenses\": 70 }\n]"

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: 12

            Label {
                Layout.fillWidth: true
                text: "Paste or edit JSON rows, then load them into the dashboard."
                color: "white"
                wrapMode: Text.Wrap
            }

            Button {
                text: "Load JSON"
                onClicked: {
                    if (dashboard.loadJson(jsonInput.text))
                        status.text = "Loaded " + dashboard.dataRows.length + " rows."
                }
            }
        }

        TextArea {
            id: jsonInput
            Layout.fillWidth: true
            Layout.preferredHeight: 145
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            text: sampleJson
            wrapMode: TextEdit.NoWrap
            font.family: "monospace"
        }

        Label {
            id: status
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            text: "Edit the JSON above and click Load JSON."
            color: "#b7c3d0"
        }

        DashboardView {
            id: dashboard
            Layout.fillWidth: true
            Layout.fillHeight: true

            onDataLoadFailed: function(message) {
                status.text = "Could not load JSON: " + message
            }
        }
    }
}
