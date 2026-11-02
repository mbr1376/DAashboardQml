// DataTable.qml - A styled data table with header, rows, and status pills
//
// Displays tabular data in a dark-themed card with:
//   - A section title
//   - Column headers
//   - Alternating row colors
//   - Colored status pill badges
//   - Hover highlighting on rows
//
// CUSTOMIZATION:
//   - Set the 'title' property for the section heading
//   - Set 'columns' to a list of column header strings
//   - Set 'rows' to a list of row objects, each containing column values
//   - The 'statusColumn' index determines which column gets pill styling
//   - Edit statusColor() to change which statuses get which colors

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    radius: 15
    color: Theme.card
    border.color: Theme.border
    border.width: 1

    // --- Public Properties ---
    property string title: "Data Table"
    property var columns: []      // e.g., ["ID", "Name", "Status", "Amount", "Date"]
    property var rows: []         // e.g., [{ id: "#1001", name: "Alice", status: "Completed", amount: "$2,450", date: "2026-02-07" }]
    property int statusColumn: 2  // Which column index contains status values

    // Column widths: if not set, columns stretch evenly
    property var columnWidths: []

    implicitHeight: headerRow.height + tableContent.height + titleLabel.height + 60

    // ============================================================
    // Section Title
    // ============================================================
    Text {
        id: titleLabel
        text: root.title
        color: Theme.textPrimary
        font { pixelSize: 16; bold: true; family: Theme.fontFamily }
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 25
    }

    // ============================================================
    // Column Headers
    // ============================================================
    Rectangle {
        id: headerRow
        anchors.top: titleLabel.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        height: 44
        color: Theme.sidebarTop

        Row {
            anchors.fill: parent

            Repeater {
                model: root.columns

                Item {
                    width: getColumnWidth(index)
                    height: parent.height

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        verticalAlignment: Text.AlignVCenter
                        text: modelData
                        color: Theme.textSecondary
                        font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                    }
                }
            }
        }
    }

    // ============================================================
    // Table Rows
    // ============================================================
    Column {
        id: tableContent
        anchors.top: headerRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 25
        anchors.rightMargin: 25

        Repeater {
            model: root.rows

            Rectangle {
                width: tableContent.width
                height: 50
                color: rowMouse.containsMouse
                       ? Theme.hover
                       : (index % 2 === 1 ? Theme.border : "transparent")

                Row {
                    anchors.fill: parent

                    Repeater {
                        model: root.columns.length

                        Item {
                            width: getColumnWidth(index)
                            height: parent.height

                            // Status pill or plain text
                            Loader {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                sourceComponent: index === root.statusColumn
                                    ? statusPillComponent : plainTextComponent

                                property string cellValue: getCellValue(
                                    root.rows[parent.parent.parent.rowIndex], index)
                            }
                        }
                    }
                }

                // Store the row index for child access
                readonly property int rowIndex: index

                MouseArea {
                    id: rowMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }

    // ============================================================
    // Cell Components
    // ============================================================

    // Plain text cell
    Component {
        id: plainTextComponent

        Text {
            text: cellValue
            color: Theme.textPrimary
            font { pixelSize: 13; family: Theme.fontFamily }
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    // Status pill cell
    Component {
        id: statusPillComponent

        Item {
            Rectangle {
                anchors.centerIn: parent
                width: pillText.implicitWidth + 24
                height: 28
                radius: 14
                color: statusColor(cellValue)

                Text {
                    id: pillText
                    anchors.centerIn: parent
                    text: cellValue
                    color: "white"
                    font { pixelSize: 11; bold: true; family: Theme.fontFamily }
                }
            }
        }
    }

    // ============================================================
    // Helper Functions
    // ============================================================

    // CUSTOMIZATION: Edit this function to change status colors
    function statusColor(status) {
        switch (status) {
            case "Completed": return Theme.accentGreen;
            case "Active":    return Theme.accentGreen;
            case "Pending":   return Theme.accentOrange;
            case "In Progress": return Theme.accentOrange;
            case "Inactive":  return Theme.accentOrange;
            case "Failed":    return Theme.accentRed;
            case "Suspended": return Theme.accentRed;
            case "Scheduled": return Theme.accentBlue;
            default:          return Theme.accentBlue;
        }
    }

    // Get the value for a specific cell from a row object
    function getCellValue(rowObj, colIndex) {
        if (!rowObj) return "";
        var keys = Object.keys(rowObj);
        if (colIndex < keys.length) return rowObj[keys[colIndex]];
        return "";
    }

    // Get column width (from columnWidths array or distribute evenly)
    function getColumnWidth(colIndex) {
        if (root.columnWidths.length > colIndex && root.columnWidths[colIndex] > 0) {
            return root.columnWidths[colIndex];
        }
        var totalAvailable = root.width - 50; // minus margins
        return totalAvailable / root.columns.length;
    }
}
