import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Flickable {
    id: root

    property var rows: []
    property var fields: rows.length > 0 ? Object.keys(rows[0]) : []
    property var numericFields: findNumericFields()
    property string groupField: fields.length > 0 ? fields[0] : ""
    property string metricField: numericFields.length > 0 ? numericFields[0] : ""
    property string aggregation: "sum"
    property string searchText: ""
    property var reportRows: buildReportRows()
    property var visibleReportRows: filterReportRows()
    property var lastGeneratedReport: null

    signal reportGenerated(var report)
    signal exportRequested(string fileName, string csv)

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

    function buildReportRows() {
        var groups = ({});
        for (var i = 0; i < rows.length; ++i) {
            var key = groupField ? String(rows[i][groupField]) : "All records";
            var groupKey = "$" + key;
            if (!groups[groupKey]) {
                groups[groupKey] = {
                    label: key, sum: 0, count: 0, records: 0,
                    minimum: Infinity, maximum: -Infinity
                };
            }

            var group = groups[groupKey];
            var value = metricField ? Number(rows[i][metricField]) : NaN;
            if (isFinite(value)) {
                group.sum += value;
                group.count += 1;
                group.minimum = Math.min(group.minimum, value);
                group.maximum = Math.max(group.maximum, value);
            }
            group.records += 1;
        }

        var result = [];
        var keys = Object.keys(groups);
        for (var k = 0; k < keys.length; ++k) {
            var item = groups[keys[k]];
            var value;
            if (aggregation === "count") {
                value = item.records;
            } else if (item.count === 0) {
                value = 0;
            } else if (aggregation === "average") {
                value = item.sum / item.count;
            } else if (aggregation === "minimum") {
                value = item.minimum;
            } else if (aggregation === "maximum") {
                value = item.maximum;
            } else {
                value = item.sum;
            }
            result.push({
                group: item.label,
                value: value,
                records: item.records
            });
        }
        return result;
    }

    function filterReportRows() {
        var query = searchText.trim().toLowerCase();
        if (!query)
            return reportRows;
        var result = [];
        for (var i = 0; i < reportRows.length; ++i) {
            var row = reportRows[i];
            if (String(row.group).toLowerCase().indexOf(query) >= 0
                    || String(row.value).toLowerCase().indexOf(query) >= 0
                    || String(row.records).toLowerCase().indexOf(query) >= 0) {
                result.push(row);
            }
        }
        return result;
    }

    function csvEscape(value) {
        var text = String(value === undefined || value === null ? "" : value);
        return '"' + text.replace(/"/g, '""') + '"';
    }

    function reportCsv(report) {
        var lines = [
            [report.groupField, report.aggregation + " " + report.metricField, "records"]
                .map(csvEscape).join(",")
        ];
        for (var i = 0; i < report.rows.length; ++i) {
            lines.push([
                report.rows[i].group,
                report.rows[i].value,
                report.rows[i].records
            ].map(csvEscape).join(","));
        }
        return lines.join("\r\n");
    }

    function generateReport() {
        var report = {
            title: reportTitle.text.trim() || "Dashboard report",
            groupField: groupField || "All records",
            metricField: aggregation === "count" ? "records" : metricField,
            aggregation: aggregation,
            sourceRecordCount: rows.length,
            rows: reportRows.slice(0)
        };
        lastGeneratedReport = report;
        reportGenerated(report);
    }

    function exportReport() {
        var report = lastGeneratedReport || {
            title: reportTitle.text.trim() || "Dashboard report",
            groupField: groupField || "All records",
            metricField: aggregation === "count" ? "records" : metricField,
            aggregation: aggregation,
            sourceRecordCount: rows.length,
            rows: reportRows.slice(0)
        };
        exportRequested("dashboard-report.csv", reportCsv(report));
    }

    onRowsChanged: {
        fields = rows.length > 0 ? Object.keys(rows[0]) : [];
        numericFields = findNumericFields();
        if (fields.indexOf(groupField) < 0)
            groupField = fields.length > 0 ? fields[0] : "";
        if (numericFields.indexOf(metricField) < 0)
            metricField = numericFields.length > 0 ? numericFields[0] : "";
        lastGeneratedReport = null;
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
                text: "Reports"
                color: Theme.textPrimary
                font { pixelSize: 24; bold: true; family: Theme.fontFamily }
            }
            Text {
                text: root.rows.length + " source records"
                color: Theme.textSecondary
                font { pixelSize: 13; family: Theme.fontFamily }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 116
            radius: 14
            color: Theme.card
            border.color: Theme.border

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                TextField {
                    id: reportTitle
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    placeholderText: "Report title"
                    text: "Data summary"
                    selectByMouse: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    ComboBox {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        model: root.fields
                        currentIndex: Math.max(0, root.fields.indexOf(root.groupField))
                        onActivated: function(index) { root.groupField = root.fields[index]; }
                    }

                    ComboBox {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        model: root.numericFields
                        currentIndex: Math.max(0, root.numericFields.indexOf(root.metricField))
                        enabled: root.numericFields.length > 0
                        onActivated: function(index) { root.metricField = root.numericFields[index]; }
                    }

                    ComboBox {
                        Layout.preferredWidth: 130
                        Layout.preferredHeight: 36
                        model: ["sum", "average", "count", "minimum", "maximum"]
                        currentIndex: Math.max(0, model.indexOf(root.aggregation))
                        onActivated: function(index) { root.aggregation = model[index]; }
                    }

                    Button {
                        text: "Generate"
                        enabled: root.rows.length > 0
                        onClicked: root.generateReport()
                    }

                    Button {
                        text: "Export CSV"
                        enabled: root.reportRows.length > 0
                        onClicked: root.exportReport()
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 14

            Repeater {
                model: [
                    { title: "Source records", value: root.rows.length },
                    { title: "Groups", value: root.reportRows.length },
                    { title: "Aggregation", value: root.aggregation }
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: 72
                    radius: 12
                    color: Theme.card
                    border.color: Theme.border
                    Column {
                        anchors.centerIn: parent
                        spacing: 5
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.title
                            color: Theme.textSecondary
                            font { pixelSize: 11; family: Theme.fontFamily }
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.value
                            color: Theme.textPrimary
                            font { pixelSize: 17; bold: true; family: Theme.fontFamily }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            radius: 14
            color: Theme.card
            border.color: Theme.border

            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 18
                anchors.topMargin: 14
                text: root.aggregation + " " + (root.metricField || "records")
                    + " by " + (root.groupField || "all records")
                color: Theme.textPrimary
                font { pixelSize: 15; bold: true; family: Theme.fontFamily }
            }

            DashboardChart {
                anchors.fill: parent
                anchors.topMargin: 40
                anchors.margins: 12
                rows: root.reportRows
                fieldNames: ["group", "value", "records"]
                widget: ({ type: "bar", xField: "group", yField: "value" })
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: reportTable.implicitHeight + 76
            radius: 14
            color: Theme.card
            border.color: Theme.border

            ColumnLayout {
                id: reportTable
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 16
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        Layout.fillWidth: true
                        text: "Generated report"
                        color: Theme.textPrimary
                        font { pixelSize: 15; bold: true; family: Theme.fontFamily }
                    }
                    TextField {
                        Layout.preferredWidth: 240
                        placeholderText: "Search report..."
                        selectByMouse: true
                        onTextChanged: root.searchText = text
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        Layout.fillWidth: true
                        text: root.groupField || "Group"
                        color: Theme.textSecondary
                        font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                    }
                    Text {
                        Layout.preferredWidth: 160
                        horizontalAlignment: Text.AlignRight
                        text: root.aggregation + " " + (root.metricField || "records")
                        color: Theme.textSecondary
                        font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                    }
                    Text {
                        Layout.preferredWidth: 100
                        horizontalAlignment: Text.AlignRight
                        text: "Records"
                        color: Theme.textSecondary
                        font { pixelSize: 12; bold: true; family: Theme.fontFamily }
                    }
                }

                Repeater {
                    model: root.visibleReportRows
                    delegate: Rectangle {
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        radius: 5
                        color: index % 2 ? Theme.border : "transparent"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            Text {
                                Layout.fillWidth: true
                                text: modelData.group
                                color: Theme.textPrimary
                                font { pixelSize: 12; family: Theme.fontFamily }
                                elide: Text.ElideRight
                            }
                            Text {
                                Layout.preferredWidth: 160
                                horizontalAlignment: Text.AlignRight
                                text: Number(modelData.value).toLocaleString(Qt.locale(), "f", 2)
                                color: Theme.textPrimary
                                font { pixelSize: 12; family: Theme.fontFamily }
                            }
                            Text {
                                Layout.preferredWidth: 100
                                horizontalAlignment: Text.AlignRight
                                text: String(modelData.records)
                                color: Theme.textSecondary
                                font { pixelSize: 12; family: Theme.fontFamily }
                            }
                        }
                    }
                }

                Text {
                    visible: root.visibleReportRows.length === 0
                    text: root.rows.length === 0 ? "Load data to generate a report."
                                                  : "No report rows match this search."
                    color: Theme.textSecondary
                    font { pixelSize: 12; family: Theme.fontFamily }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.lastGeneratedReport !== null
            text: root.lastGeneratedReport
                ? "Generated: " + root.lastGeneratedReport.title
                    + " — " + root.lastGeneratedReport.rows.length + " groups"
                : ""
            color: Theme.accentGreen
            font { pixelSize: 12; family: Theme.fontFamily }
        }
    }
}
