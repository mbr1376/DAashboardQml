import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property var widget: ({})
    property var rows: []
    property var fieldNames: []
    property bool editMode: false
    readonly property var chartTypes: ["line", "bar", "area", "scatter", "pie", "donut", "table"]

    signal fieldChanged(string name, var value)
    signal removeRequested()
    signal dragStarted()
    signal dragMoved(real x, real y)
    signal dragFinished()
    signal resizeStarted()
    signal resizeMoved(real x, real y)
    signal resizeFinished()

    radius: 14
    color: Theme.card
    border.color: Theme.border
    border.width: 1
    clip: true

    Rectangle {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 46
        color: "transparent"

        Item {
            id: dragArea
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width * 0.42
            height: parent.height
        }

        Text {
            id: titleLabel
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(50, parent.width * 0.34)
            text: root.widget.title || "Widget"
            color: Theme.textPrimary
            font { pixelSize: 14; bold: true; family: Theme.fontFamily }
            elide: Text.ElideRight
        }

        ComboBox {
            id: typeSelector
            visible: root.editMode
            anchors.left: titleLabel.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            width: 92
            height: 30
            model: root.chartTypes
            currentIndex: Math.max(0, root.chartTypes.indexOf(root.widget.type || "line"))
            onActivated: function(index) {
                root.fieldChanged("type", root.chartTypes[index]);
            }
        }

        Button {
            visible: root.editMode
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            width: 34
            height: 32
            text: "×"
            onClicked: root.removeRequested()
        }

        DragHandler {
            parent: dragArea
            enabled: root.editMode
            target: null
            onActiveChanged: {
                if (active)
                    root.dragStarted();
                else
                    root.dragFinished();
            }
            onTranslationChanged: root.dragMoved(translation.x, translation.y)
        }
    }

    RowLayout {
        id: fieldsRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        height: root.editMode && root.widget.type !== "table" ? 34 : 0
        spacing: 8
        visible: height > 0

        ComboBox {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            model: root.fieldNames
            currentIndex: Math.max(0, root.fieldNames.indexOf(root.widget.xField))
            onActivated: function(index) {
                root.fieldChanged("xField", root.fieldNames[index]);
            }
        }

        ComboBox {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            model: root.fieldNames
            currentIndex: Math.max(0, root.fieldNames.indexOf(root.widget.yField))
            onActivated: function(index) {
                root.fieldChanged("yField", root.fieldNames[index]);
            }
        }
    }

    Item {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: fieldsRow.visible ? fieldsRow.bottom : header.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 12
        anchors.topMargin: 4
        anchors.bottomMargin: 12

        DashboardChart {
            anchors.fill: parent
            visible: root.widget.type !== "table"
            rows: root.rows
            widget: root.widget
            fieldNames: root.fieldNames
        }

        Column {
            visible: root.widget.type === "table"
            anchors.fill: parent
            spacing: 0

            Rectangle {
                id: tableHeader
                width: parent.width
                height: 30
                color: Theme.sidebarTop

                Row {
                    id: headerColumns
                    anchors.fill: parent
                    Repeater {
                        model: root.fieldNames
                        delegate: Item {
                            id: headerColumn
                            required property var modelData
                            width: root.fieldNames.length > 0
                                ? headerColumns.width / root.fieldNames.length : 0
                            height: tableHeader.height
                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 7
                                anchors.rightMargin: 5
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                text: String(headerColumn.modelData)
                                color: Theme.textSecondary
                                font { pixelSize: 10; bold: true; family: Theme.fontFamily }
                            }
                        }
                    }
                }
            }

            ListView {
                width: parent.width
                height: Math.max(0, parent.height - 30)
                clip: true
                model: root.rows
                delegate: Rectangle {
                    id: tableRow
                    required property var modelData
                    required property int index
                    property var rowData: modelData
                    width: ListView.view.width
                    height: 32
                    color: index % 2 ? Theme.border : "transparent"

                    Row {
                        id: dataColumns
                        anchors.fill: parent
                        Repeater {
                            model: root.fieldNames
                            delegate: Item {
                                id: cell
                                required property var modelData
                                width: root.fieldNames.length > 0
                                    ? dataColumns.width / root.fieldNames.length : 0
                                height: dataColumns.height
                                Text {
                                    anchors.fill: parent
                                    anchors.leftMargin: 7
                                    anchors.rightMargin: 5
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                    text: tableRow.rowData[cell.modelData] === undefined
                                        ? "" : String(tableRow.rowData[cell.modelData])
                                    color: Theme.textPrimary
                                    font { pixelSize: 10; family: Theme.fontFamily }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        id: resizeHandle
        visible: root.editMode
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 24
        height: 24

        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.strokeStyle = Theme.textSecondary;
                ctx.lineWidth = 2;
                for (var i = 0; i < 3; ++i) {
                    ctx.beginPath();
                    ctx.moveTo(width - 5, height - 7 - i * 5);
                    ctx.lineTo(width - 7 - i * 5, height - 5);
                    ctx.stroke();
                }
            }
        }

        DragHandler {
            parent: resizeHandle
            enabled: root.editMode
            target: null
            onActiveChanged: {
                if (active)
                    root.resizeStarted();
                else
                    root.resizeFinished();
            }
            onTranslationChanged: root.resizeMoved(translation.x, translation.y)
        }
    }
}
