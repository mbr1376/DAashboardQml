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
    title: "Dashboard - REST API example"
    color: Theme.background
    property bool requestStarted: false

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: 12

            TextField {
                id: apiUrl
                Layout.fillWidth: true
                placeholderText: "HTTP or HTTPS API URL"
                text: "https://jsonplaceholder.typicode.com/posts?_limit=20"
            }

            TextField {
                id: bearerToken
                Layout.preferredWidth: 190
                placeholderText: "Optional bearer token"
                echoMode: TextInput.Password
            }

            Button {
                text: dashboard.loading ? "Loading..." : "Fetch API"
                enabled: !dashboard.loading
                onClicked: {
                    if (dashboard.loadRest(apiUrl.text, bearerToken.text)) {
                        requestStarted = true
                        status.text = "Request sent. Waiting for the API..."
                    }
                }
            }
        }

        Label {
            id: status
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            text: "This endpoint returns an array of post objects. Enter any API URL returning a JSON array, { data: [...] }, or { rows: [...] }."
            color: "#b7c3d0"
            wrapMode: Text.Wrap
        }

        DashboardView {
            id: dashboard
            Layout.fillWidth: true
            Layout.fillHeight: true
            dashboardLayout: [
                { id: "posts-by-user", title: "Post IDs by user", type: "bar",
                  x: 0, y: 0, w: 6, h: 3, xField: "userId", yField: "id" },
                { id: "post-id-line", title: "Post ID trend", type: "line",
                  x: 6, y: 0, w: 6, h: 3, xField: "id", yField: "userId" },
                { id: "post-table", title: "API response rows", type: "table",
                  x: 0, y: 3, w: 12, h: 3, xField: "title", yField: "id" }
            ]

            onDataLoadFailed: function(message) {
                requestStarted = false
                status.text = "API request failed: " + message
            }
        }

        Connections {
            target: dashboard
            function onLoadingChanged() {
                if (requestStarted && !dashboard.loading) {
                    requestStarted = false
                    status.text = "API response received."
                }
            }
        }
    }
}
