// UsersPage.qml - User management view with stats, filters, table, and chart
//
// Displays:
//   - 3 stat cards for user counts (Total Users, Active Now, New This Week)
//   - Search/filter bar with role, status dropdowns, and "Add User" button
//   - User management table with avatars, roles, status pills, and actions
//   - Role distribution donut chart
//
// CUSTOMIZATION:
//   - Edit stat card values for your own user counts
//   - Modify usersData for your own user list
//   - Change role colors in the roleBadgeColor() function
//   - Change status colors in the statusColor() function

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Flickable {
    id: usersPage
    contentWidth: width
    contentHeight: contentColumn.height + 60
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    ColumnLayout {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 30
        anchors.topMargin: 25
        spacing: 25

        // ============================================================
        // User Stats Row - 3 Summary Cards
        // ============================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            StatCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                iconChar: "\u25CB"
                title: "Total Users"
                value: "2,847"
                change: "+124"
                positive: true
                accentColor: Theme.accentBlue
            }

            StatCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                iconChar: "\u25C8"
                title: "Active Now"
                value: "389"
                change: "+18"
                positive: true
                accentColor: Theme.accentGreen
            }

            StatCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                iconChar: "\u25CE"
                title: "New This Week"
                value: "67"
                change: "-5"
                positive: false
                accentColor: Theme.accentOrange
            }

            // Spacer to match 3-card layout with stretch
            Item { Layout.fillWidth: true }
        }

        // ============================================================
        // Search/Filter Bar
        // ============================================================
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 58
            radius: 15
            color: Theme.card
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                spacing: 12

                // Search input
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 38
                    radius: 19
                    color: Theme.background
                    border.color: userSearch.activeFocus ? Theme.accentBlue : Theme.border
                    border.width: 1

                    TextInput {
                        id: userSearch
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        verticalAlignment: TextInput.AlignVCenter
                        color: Theme.textPrimary
                        font { pixelSize: 13; family: Theme.fontFamily }
                        clip: true

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            text: "Search users by name or email..."
                            color: Theme.textSecondary
                            font: userSearch.font
                            visible: !userSearch.text && !userSearch.activeFocus
                        }
                    }
                }

                // Role filter
                ComboBox {
                    id: roleFilter
                    model: ["All Roles", "Admin", "Editor", "Viewer", "Guest"]
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 38
                    background: Rectangle {
                        radius: 8; color: Theme.background
                        border.color: roleFilter.hovered ? Theme.accentBlue : Theme.border
                        border.width: 1
                    }
                    contentItem: Text {
                        text: roleFilter.displayText
                        color: Theme.textPrimary
                        font { pixelSize: 13; family: Theme.fontFamily }
                        verticalAlignment: Text.AlignVCenter; leftPadding: 15
                    }
                    popup.background: Rectangle { color: Theme.card; border.color: Theme.border; radius: 8 }
                    delegate: ItemDelegate {
                        width: roleFilter.width
                        contentItem: Text { text: modelData; color: Theme.textPrimary; font { pixelSize: 13; family: Theme.fontFamily } }
                        background: Rectangle { color: highlighted ? Theme.hover : "transparent" }
                        highlighted: roleFilter.highlightedIndex === index
                    }
                }

                // Status filter
                ComboBox {
                    id: userStatusFilter
                    model: ["All Statuses", "Active", "Inactive", "Suspended"]
                    Layout.preferredWidth: 160
                    Layout.preferredHeight: 38
                    background: Rectangle {
                        radius: 8; color: Theme.background
                        border.color: userStatusFilter.hovered ? Theme.accentBlue : Theme.border
                        border.width: 1
                    }
                    contentItem: Text {
                        text: userStatusFilter.displayText
                        color: Theme.textPrimary
                        font { pixelSize: 13; family: Theme.fontFamily }
                        verticalAlignment: Text.AlignVCenter; leftPadding: 15
                    }
                    popup.background: Rectangle { color: Theme.card; border.color: Theme.border; radius: 8 }
                    delegate: ItemDelegate {
                        width: userStatusFilter.width
                        contentItem: Text { text: modelData; color: Theme.textPrimary; font { pixelSize: 13; family: Theme.fontFamily } }
                        background: Rectangle { color: highlighted ? Theme.hover : "transparent" }
                        highlighted: userStatusFilter.highlightedIndex === index
                    }
                }

                // Add User button
                Rectangle {
                    Layout.preferredWidth: addUserText.implicitWidth + 48
                    Layout.preferredHeight: 38
                    radius: 19
                    color: addUserMouse.containsMouse ? "#2980b9" : Theme.accentBlue

                    Text {
                        id: addUserText
                        anchors.centerIn: parent
                        text: "Add User"
                        color: "white"
                        font { pixelSize: 13; bold: true; family: Theme.fontFamily }
                    }

                    MouseArea {
                        id: addUserMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                    }
                }
            }
        }

        // ============================================================
        // Users Table
        // CUSTOMIZATION: Edit usersData to change the user list
        // ============================================================
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: userTableColumn.height + usersTableTitle.height + 50
            radius: 15
            color: Theme.card
            border.color: Theme.border
            border.width: 1

            Text {
                id: usersTableTitle
                text: "All Users"
                color: Theme.textPrimary
                font { pixelSize: 16; bold: true; family: Theme.fontFamily }
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 20
                anchors.leftMargin: 25
            }

            Column {
                id: userTableColumn
                anchors.top: usersTableTitle.bottom
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 25
                anchors.rightMargin: 25

                // Header row
                Rectangle {
                    width: parent.width
                    height: 44
                    color: Theme.sidebarTop

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Text {
                            text: "User"
                            color: Theme.textSecondary
                            font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                            Layout.fillWidth: true
                            leftPadding: 12
                        }
                        Text {
                            text: "Role"
                            color: Theme.textSecondary
                            font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                            Layout.preferredWidth: 120
                            leftPadding: 12
                        }
                        Text {
                            text: "Status"
                            color: Theme.textSecondary
                            font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                            Layout.preferredWidth: 130
                            leftPadding: 12
                        }
                        Text {
                            text: "Last Active"
                            color: Theme.textSecondary
                            font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                            Layout.preferredWidth: 120
                            leftPadding: 12
                        }
                        Text {
                            text: "Activity"
                            color: Theme.textSecondary
                            font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                            Layout.preferredWidth: 80
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            text: "Actions"
                            color: Theme.textSecondary
                            font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                            Layout.preferredWidth: 70
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }

                // User rows
                property var usersData: [
                    { name: "Alice Johnson",  email: "alice@company.com",  initials: "AJ", role: "Admin",  status: "Active",    lastActive: "2 min ago",  activity: "95%", avatarColor: "#3498db" },
                    { name: "Bob Martinez",   email: "bob@company.com",    initials: "BM", role: "Editor", status: "Active",    lastActive: "15 min ago", activity: "82%", avatarColor: "#2ecc71" },
                    { name: "Carol Williams", email: "carol@company.com",  initials: "CW", role: "Viewer", status: "Active",    lastActive: "1 hour ago", activity: "67%", avatarColor: "#e74c3c" },
                    { name: "David Kim",      email: "david@company.com",  initials: "DK", role: "Admin",  status: "Inactive",  lastActive: "2 days ago", activity: "34%", avatarColor: "#f39c12" },
                    { name: "Eva Chen",       email: "eva@company.com",    initials: "EC", role: "Editor", status: "Active",    lastActive: "5 min ago",  activity: "91%", avatarColor: "#9b59b6" },
                    { name: "Frank O'Brien",  email: "frank@company.com",  initials: "FO", role: "Viewer", status: "Suspended", lastActive: "1 week ago", activity: "12%", avatarColor: "#3498db" },
                    { name: "Grace Nakamura", email: "grace@company.com",  initials: "GN", role: "Editor", status: "Active",    lastActive: "30 min ago", activity: "78%", avatarColor: "#2ecc71" },
                    { name: "Henry Patel",    email: "henry@company.com",  initials: "HP", role: "Guest",  status: "Active",    lastActive: "3 hours ago",activity: "45%", avatarColor: "#e74c3c" },
                    { name: "Iris Andersson", email: "iris@company.com",   initials: "IA", role: "Viewer", status: "Active",    lastActive: "10 min ago", activity: "88%", avatarColor: "#f39c12" },
                    { name: "James Wilson",   email: "james@company.com",  initials: "JW", role: "Admin",  status: "Active",    lastActive: "Just now",   activity: "97%", avatarColor: "#9b59b6" }
                ]

                Repeater {
                    model: userTableColumn.usersData

                    Rectangle {
                        width: userTableColumn.width
                        height: 60
                        color: userRowMouse.containsMouse
                               ? Theme.hover
                               : (index % 2 === 1 ? Theme.border : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            // User avatar + name + email
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Row {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    spacing: 10

                                    Rectangle {
                                        width: 36; height: 36; radius: 18
                                        color: modelData.avatarColor

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.initials
                                            color: "white"
                                            font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                                        }
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2

                                        Text {
                                            text: modelData.name
                                            color: Theme.textPrimary
                                            font { pixelSize: 13; bold: true; family: Theme.fontFamily }
                                        }
                                        Text {
                                            text: modelData.email
                                            color: Theme.textSecondary
                                            font { pixelSize: 11; family: Theme.fontFamily }
                                        }
                                    }
                                }
                            }

                            // Role badge
                            Item {
                                Layout.preferredWidth: 120
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 85; height: 26; radius: 13
                                    color: roleBadgeColor(modelData.role)

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.role
                                        color: "white"
                                        font { pixelSize: 11; bold: true; family: Theme.fontFamily }
                                    }
                                }
                            }

                            // Status pill
                            Item {
                                Layout.preferredWidth: 130
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 95; height: 28; radius: 14
                                    color: statusColor(modelData.status)

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.status
                                        color: "white"
                                        font { pixelSize: 11; bold: true; family: Theme.fontFamily }
                                    }
                                }
                            }

                            // Last Active
                            Text {
                                text: modelData.lastActive
                                color: Theme.textPrimary
                                font { pixelSize: 13; family: Theme.fontFamily }
                                Layout.preferredWidth: 120
                                horizontalAlignment: Text.AlignHCenter
                            }

                            // Activity
                            Text {
                                text: modelData.activity
                                color: Theme.textPrimary
                                font { pixelSize: 13; family: Theme.fontFamily }
                                Layout.preferredWidth: 80
                                horizontalAlignment: Text.AlignHCenter
                            }

                            // Actions button
                            Item {
                                Layout.preferredWidth: 70
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 36; height: 36; radius: 8
                                    color: moreMouse.containsMouse ? Theme.hover : "transparent"
                                    border.color: Theme.border
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: "\u22EF"
                                        color: moreMouse.containsMouse ? Theme.textPrimary : Theme.textSecondary
                                        font { pixelSize: 16; family: Theme.fontFamily }
                                    }

                                    MouseArea {
                                        id: moreMouse
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: userRowMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            z: -1
                        }
                    }
                }
            }
        }

        // ============================================================
        // Role Distribution Chart
        // ============================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 2
                Layout.preferredHeight: 350
                radius: 15
                color: Theme.card
                border.color: Theme.border
                border.width: 1

                Text {
                    text: "Role Distribution"
                    color: Theme.textPrimary
                    font { pixelSize: 15; bold: true; family: Theme.fontFamily }
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 15
                    anchors.leftMargin: 25
                }

                DonutChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 15
                    slices: [
                        { label: "Admin",  value: 3, color: "#e74c3c" },
                        { label: "Editor", value: 3, color: "#3498db" },
                        { label: "Viewer", value: 3, color: "#2ecc71" },
                        { label: "Guest",  value: 1, color: "#9b59b6" }
                    ]
                }
            }

            // Empty spacer to match the 2:3 ratio used on other pages
            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: 3
            }
        }

        Item { Layout.preferredHeight: 10 }
    }

    // ============================================================
    // Helper Functions
    // ============================================================

    // CUSTOMIZATION: Change role badge colors here
    function roleBadgeColor(role) {
        switch (role) {
            case "Admin":  return Theme.accentRed;
            case "Editor": return Theme.accentBlue;
            case "Viewer": return Theme.accentGreen;
            case "Guest":  return Theme.accentPurple;
            default:       return Theme.accentBlue;
        }
    }

    // CUSTOMIZATION: Change status pill colors here
    function statusColor(status) {
        switch (status) {
            case "Active":    return Theme.accentGreen;
            case "Inactive":  return Theme.accentOrange;
            case "Suspended": return Theme.accentRed;
            default:          return Theme.accentBlue;
        }
    }
}
