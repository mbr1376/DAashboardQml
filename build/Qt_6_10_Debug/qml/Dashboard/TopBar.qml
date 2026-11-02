// TopBar.qml - Top header bar with breadcrumb, search, and profile
//
// Displays a horizontal bar across the top of the content area:
//   - Left side:  Breadcrumb text showing current page
//   - Right side: Search bar, notification bell, profile avatar
//
// CUSTOMIZATION:
//   - Change breadcrumbText to update the displayed path
//   - Edit the notification count in the bell Canvas
//   - Change user initials/name in the avatar section

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: topBar
    height: 70
    color: Theme.background

    // The breadcrumb text is set by the parent when pages change
    property string breadcrumbText: "Dashboard  /  Overview"

    // Bottom border line
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width; height: 1
        color: Theme.border
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 20
        spacing: 15

        // ============================================================
        // Left: Breadcrumb
        // ============================================================
        Text {
            text: topBar.breadcrumbText
            color: Theme.textSecondary
            font { pixelSize: 14; family: Theme.fontFamily }
            Layout.fillWidth: true
        }

        // ============================================================
        // Right: Search Bar
        // ============================================================
        Rectangle {
            Layout.preferredWidth: 220
            Layout.preferredHeight: 38
            radius: 19
            color: Theme.card
            border.color: searchInput.activeFocus ? Theme.accentBlue : Theme.border
            border.width: 1

            TextInput {
                id: searchInput
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.textPrimary
                font { pixelSize: 13; family: Theme.fontFamily }
                clip: true

                // Placeholder text
                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    text: "Search..."
                    color: Theme.textSecondary
                    font: searchInput.font
                    visible: !searchInput.text && !searchInput.activeFocus
                }
            }
        }

        // ============================================================
        // Right: Notification Bell (Canvas-drawn)
        // ============================================================
        Item {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40

            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    // Bell icon (Unicode musical note as placeholder)
                    ctx.font = "18px '" + Theme.fontFamily + "'";
                    ctx.fillStyle = Theme.textSecondary;
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText("\u266A", width / 2, height / 2);

                    // Red notification badge
                    ctx.beginPath();
                    ctx.arc(30, 8, 8, 0, Math.PI * 2);
                    ctx.fillStyle = Theme.accentRed;
                    ctx.fill();

                    // Badge number
                    ctx.font = "bold 8px '" + Theme.fontFamily + "'";
                    ctx.fillStyle = "#ffffff";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText("3", 30, 8);
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
            }
        }

        // ============================================================
        // Right: Profile Avatar
        // ============================================================
        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            radius: 20
            color: Theme.accentBlue

            Text {
                anchors.centerIn: parent
                text: "JD"
                color: "white"
                font { pixelSize: 12; bold: true; family: Theme.fontFamily }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
            }
        }
    }
}
