import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Flickable {
    id: root

    property var rows: []
    property var fields: rows.length > 0 ? Object.keys(rows[0]) : []
    property var numericFields: findNumericFields()
    property string categoryField: fields.length > 0 ? fields[0] : ""
    property string metricField: numericFields.length > 0 ? numericFields[0] : ""
    property string chartType: "line"

    contentWidth: width
    contentHeight: contentColumn.height + 48
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    function findNumericFields() {
        if (rows.length === 0)
            return [];
        var result = [];
        for (var i = 0; i < fields.length; ++i) {
            var value = rows[0][fields[i]];
            if (value !== null && value !== "" && isFinite(Number(value)))
                result.push(fields[i]);
        }
        return result;
    }

    function totalValue() {
        var total = 0;
        for (var i = 0; i < rows.length; ++i) {
            var value = Number(rows[i][metricField]);
            if (isFinite(value))
                total += value;
        }
        return total;
    }

    function averageValue() {
        var count = 0;
        for (var i = 0; i < rows.length; ++i) {
            if (isFinite(Number(rows[i][metricField])))
                ++count;
        }
        return count > 0 ? totalValue() / count : 0;
    }

    function uniqueValueCount() {
        var values = [];
        for (var i = 0; i < rows.length; ++i) {
            var value = String(rows[i][categoryField]);
            if (values.indexOf(value) < 0)
                values.push(value);
        }
        return values.length;
    }

    function largestRows() {
        var result = rows.slice(0);
        result.sort(function(left, right) {
            return Number(right[metricField]) - Number(left[metricField]);
        });
        return result.slice(0, 5);
    }

    function displayNumber(value) {
        return Number(value).toLocaleString(Qt.locale(), "f", 2);
    }

    onRowsChanged: {
        fields = rows.length > 0 ? Object.keys(rows[0]) : [];
        numericFields = findNumericFields();
        if (fields.indexOf(categoryField) < 0)
            categoryField = fields.length > 0 ? fields[0] : "";
        if (numericFields.indexOf(metricField) < 0)
            metricField = numericFields.length > 0 ? numericFields[0] : "";
    }

    ColumnLayout {
        id: contentColumn
        width: Math.max(0, root.width - 48)
        x: 24
        y: 20
        spacing: 18

        RowLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                text: "Analytics"
                color: Theme.textPrimary
                font { pixelSize: 24; bold: true; family: Theme.fontFamily }
            }
            Text {
                text: root.rows.length + " records"
                color: Theme.textSecondary
                font { pixelSize: 13; family: Theme.fontFamily }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Repeater {
                model: [
                    { title: "Records", value: root.rows.length, color: Theme.accentBlue },
                    { title: "Total " + (root.metricField || "value"),
                      value: root.metricField ? root.displayNumber(root.totalValue()) : "—",
                      color: Theme.accentGreen },
                    { title: "Average " + (root.metricField || "value"),
                      value: root.metricField ? root.displayNumber(root.averageValue()) : "—",
                      color: Theme.accentOrange },
                    { title: "Unique " + (root.categoryField || "values"),
                      value: root.categoryField ? root.uniqueValueCount() : "—",
                      color: Theme.accentPurple }
                ]

                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    radius: 12
                    color: Theme.card
                    border.color: Theme.border

                    Rectangle {
                        width: 4
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        color: modelData.color
                        radius: 2
                    }
                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 18
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8
                        Text {
                            text: modelData.title
                            color: Theme.textSecondary
                            font { pixelSize: 12; family: Theme.fontFamily }
                        }
                        Text {
                            text: modelData.value
                            color: Theme.textPrimary
                            font { pixelSize: 22; bold: true; family: Theme.fontFamily }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            radius: 12
            color: Theme.card
            border.color: Theme.border

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 10

                Text {
                    text: "Group by"
                    color: Theme.textSecondary
                    font { pixelSize: 12; family: Theme.fontFamily }
                }
                ComboBox {
                    Layout.preferredWidth: 170
                    model: root.fields
                    currentIndex: Math.max(0, root.fields.indexOf(root.categoryField))
                    onActivated: function(index) { root.categoryField = root.fields[index]; }
                }
                Text {
                    text: "Measure"
                    color: Theme.textSecondary
                    font { pixelSize: 12; family: Theme.fontFamily }
                }
                ComboBox {
                    Layout.preferredWidth: 170
                    model: root.numericFields
                    currentIndex: Math.max(0, root.numericFields.indexOf(root.metricField))
                    onActivated: function(index) { root.metricField = root.numericFields[index]; }
                }
                Item { Layout.fillWidth: true }
                ComboBox {
                    Layout.preferredWidth: 130
                    model: ["line", "bar", "area", "scatter", "pie", "donut"]
                    currentIndex: Math.max(0, model.indexOf(root.chartType))
                    onActivated: function(index) { root.chartType = model[index]; }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(280, root.height * 0.43)
            radius: 14
            color: Theme.card
            border.color: Theme.border

            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 18
                anchors.topMargin: 14
                text: (root.metricField || "Value") + " by " + (root.categoryField || "category")
                color: Theme.textPrimary
                font { pixelSize: 15; bold: true; family: Theme.fontFamily }
            }

            DashboardChart {
                anchors.fill: parent
                anchors.topMargin: 42
                anchors.margins: 12
                rows: root.rows
                fieldNames: root.fields
                widget: ({
                    type: root.chartType,
                    xField: root.categoryField,
                    yField: root.metricField
                })
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: topValuesColumn.implicitHeight + 48
            radius: 14
            color: Theme.card
            border.color: Theme.border

            Column {
                id: topValuesColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 18
                spacing: 10

                Text {
                    text: "Largest records"
                    color: Theme.textPrimary
                    font { pixelSize: 15; bold: true; family: Theme.fontFamily }
                }

                Repeater {
                    model: root.largestRows()
                    delegate: RowLayout {
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        Text {
                            Layout.fillWidth: true
                            text: String(modelData[root.categoryField] === undefined
                                         ? "Row " + (index + 1)
                                         : modelData[root.categoryField])
                            color: Theme.textSecondary
                            font { pixelSize: 12; family: Theme.fontFamily }
                            elide: Text.ElideRight
                        }
                        Text {
                            text: root.metricField
                                ? root.displayNumber(modelData[root.metricField]) : "—"
                            color: Theme.textPrimary
                            font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                        }
                    }
                }

                Text {
                    visible: root.rows.length === 0
                    text: "Load data to view analytics."
                    color: Theme.textSecondary
                    font { pixelSize: 12; family: Theme.fontFamily }
                }
            }
        }
    }
}
