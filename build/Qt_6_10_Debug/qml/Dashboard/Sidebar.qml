// Sidebar.qml - Left navigation panel for the dashboard
//
// Displays a dark gradient sidebar with:
//   - A diamond logo and "Dashboard" title at the top
//   - 4 navigation buttons with hover/active states
//   - A settings button and user avatar at the bottom
//
// CUSTOMIZATION:
//   - Change the navModel list to add/remove navigation items
//   - Edit the Canvas in the logo section to draw your own logo
//   - Change user name/initials in the avatar section at the bottom

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: sidebar
    width: 250

    // Signal emitted when the user clicks a navigation item
    signal navigationChanged(int index)

    // Current active page index
    property int currentIndex: 0

    // CUSTOMIZATION: Edit this list to change sidebar navigation items
    // Each entry is { icon: "unicode", text: "Label" }
    readonly property var navModel: [
        { icon: "\u25C8", text: "Dashboard" },
        { icon: "\u25CE", text: "Analytics" },
        { icon: "\u25A3", text: "Reports" },
        { icon: "\u25CB", text: "Users" },
    ]

    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.sidebarTop }
        GradientStop { position: 1.0; color: Theme.sidebarBottom }
    }

    // Right border
    Rectangle {
        anchors.right: parent.right
        width: 1; height: parent.height
        color: Theme.border
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.bottomMargin: 15
        spacing: 2

        // ============================================================
        // Logo Area - Diamond icon + "Dashboard" text
        // ============================================================
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 80

            Canvas {
                id: logoCanvas
                anchors.centerIn: parent
                width: 200; height: 80

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    var cx = width / 2;
                    var iconSize = 18;
                    var iconY = 10;

                    // Diamond shape
                    ctx.beginPath();
                    ctx.moveTo(cx, iconY);
                    ctx.lineTo(cx + iconSize, iconY + iconSize);
                    ctx.lineTo(cx, iconY + iconSize * 2);
                    ctx.lineTo(cx - iconSize, iconY + iconSize);
                    ctx.closePath();

                    // Gradient fill
                    var grad = ctx.createLinearGradient(cx, iconY, cx, iconY + iconSize * 2);
                    grad.addColorStop(0, Theme.accentBlue);
                    grad.addColorStop(1, "#2980b9");
                    ctx.fillStyle = grad;
                    ctx.fill();

                    // "Dashboard" text
                    ctx.font = "bold 16px '" + Theme.fontFamily + "'";
                    ctx.fillStyle = Theme.textPrimary;
                    ctx.textAlign = "center";
                    ctx.fillText("Dashboard", cx, 68);
                }
            }
        }

        Item { Layout.preferredHeight: 10 }

        // ============================================================
        // Navigation Buttons
        // ============================================================
        Repeater {
            model: sidebar.navModel

            delegate: Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: mouseArea.containsMouse || sidebar.currentIndex === index
                       ? Theme.hover : "transparent"

                // Active/hover left border
                Rectangle {
                    anchors.left: parent.left
                    width: 3; height: parent.height
                    color: mouseArea.containsMouse || sidebar.currentIndex === index
                           ? Theme.accentBlue : "transparent"
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: "  " + modelData.icon + "   " + modelData.text
                    color: sidebar.currentIndex === index
                           ? Theme.accentBlue
                           : (mouseArea.containsMouse ? Theme.textPrimary
                                                      : Theme.textSecondary)
                    font.pixelSize: 14
                    font.family: Theme.fontFamily
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        sidebar.currentIndex = index;
                        sidebar.navigationChanged(index);
                    }
                }
            }
        }

        // Spacer pushes bottom items down
        Item { Layout.fillHeight: true }

        // ============================================================
        // Separator
        // ============================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 20; Layout.rightMargin: 20
            height: 1
            color: Theme.border
        }

        Item { Layout.preferredHeight: 5 }

        // ============================================================
        // Settings Button
        // ============================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            color: settingsMouse.containsMouse ? Theme.hover : "transparent"

            Rectangle {
                anchors.left: parent.left
                width: 3; height: parent.height
                color: settingsMouse.containsMouse ? Theme.accentBlue : "transparent"
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                text: "  \u2699   Settings"
                color: settingsMouse.containsMouse ? Theme.textPrimary : Theme.textSecondary
                font.pixelSize: 13
                font.family: Theme.fontFamily
            }

            MouseArea {
                id: settingsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }
        }

        // ============================================================
        // User Avatar
        // ============================================================
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            // CUSTOMIZATION: Change initials, name, and role here
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Rectangle {
                    width: 36; height: 36; radius: 18
                    color: Theme.accentBlue

                    Text {
                        anchors.centerIn: parent
                        text: "JD"
                        color: "white"
                        font { pixelSize: 13; bold: true; family: Theme.fontFamily }
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: "John Doe"
                        color: Theme.textPrimary
                        font { pixelSize: 12; weight: Font.DemiBold; family: Theme.fontFamily }
                    }
                    Text {
                        text: "Admin"
                        color: Theme.textSecondary
                        font { pixelSize: 10; family: Theme.fontFamily }
                    }
                }
            }
        }
    }
}
