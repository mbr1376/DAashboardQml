// DashboardView.qml - Embeddable root item for Qt Quick applications
//
// The standalone application wraps this item in a Window. Other applications
// can place DashboardView directly inside their own QML scene.

import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: 1400
    implicitHeight: 900

    property var dataModel: null
    property var dashboardLayout: [
        { id: "sales-line", title: "Sales by category", type: "line",
          x: 0, y: 0, w: 6, h: 3, xField: "category", yField: "sales" },
        { id: "orders-bar", title: "Orders by category", type: "bar",
          x: 6, y: 0, w: 6, h: 3, xField: "category", yField: "orders" },
        { id: "sales-donut", title: "Sales distribution", type: "donut",
          x: 0, y: 3, w: 5, h: 3, xField: "category", yField: "sales" },
        { id: "data-table", title: "All data", type: "table",
          x: 5, y: 3, w: 7, h: 3, xField: "category", yField: "sales" }
    ]

    readonly property var pageNames: [
        "Dashboard  /  Overview",
        "Analytics  /  Traffic & Engagement",
        "Reports  /  Documents & Exports",
        "Users  /  Management"
    ]

    readonly property var dataRows: dataSource.rows

    signal layoutChanged(var layout)
    signal saveLayoutRequested(var layout)
    signal dataLoadFailed(string message)
    signal reportGenerated(var report)
    signal reportExportRequested(string fileName, string csv)

    function setData(rows) {
        return dataSource.setRows(rows);
    }

    function setDataModel(model) {
        if (dataModel === model)
            return dataSource.setSource(model);
        dataModel = model;
        return true;
    }

    function loadJson(json) {
        return dataSource.loadJson(json);
    }

    function loadCsv(csv) {
        return dataSource.loadCsv(csv);
    }

    function loadFile(url) {
        return dataSource.loadFile(url);
    }

    function loadRest(url, bearerToken) {
        return dataSource.loadUrl(url, bearerToken || "");
    }

    function setLayout(layout) {
        if (!builder)
            return false;
        if (!builder.setLayout(layout))
            return false;
        dashboardLayout = layout;
        return true;
    }

    DashboardDataSource {
        id: dataSource
        onErrorMessageChanged: {
            if (dataSource.errorMessage.length > 0)
                root.dataLoadFailed(dataSource.errorMessage);
        }
    }

    onDataModelChanged: dataSource.setSource(dataModel)

    onDashboardLayoutChanged: {
        if (builder && builder.widgets !== dashboardLayout)
            builder.setLayout(dashboardLayout);
    }

    Component.onCompleted: {
        if (dataModel === null && dataSource.rows.length === 0) {
            dataSource.setRows([
                { category: "Online", sales: 240, orders: 120, expenses: 72 },
                { category: "Retail", sales: 185, orders: 94, expenses: 63 },
                { category: "Wholesale", sales: 310, orders: 61, expenses: 110 },
                { category: "Partner", sales: 155, orders: 48, expenses: 52 },
                { category: "Mobile", sales: 205, orders: 108, expenses: 70 },
                { category: "Other", sales: 95, orders: 39, expenses: 33 }
            ]);
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Sidebar {
            id: sidebar
            Layout.fillHeight: true

            onNavigationChanged: function(index) {
                pageStack.currentIndex = index;
                if (index >= 0 && index < root.pageNames.length) {
                    topBar.breadcrumbText = root.pageNames[index];
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            TopBar {
                id: topBar
                Layout.fillWidth: true
            }

            StackLayout {
                id: pageStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: 0

                DashboardBuilder {
                    id: builder
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    rows: root.dataRows
                    source: dataSource
                    widgets: root.dashboardLayout

                    onLayoutChanged: function(layout) {
                        root.dashboardLayout = layout;
                        root.layoutChanged(layout);
                    }
                    onSaveRequested: function(layout) {
                        root.saveLayoutRequested(layout);
                    }
                }
                AnalyticsPage {
                    rows: root.dataRows
                }
                ReportsPage {
                    rows: root.dataRows
                    onReportGenerated: function(report) {
                        root.reportGenerated(report);
                    }
                    onExportRequested: function(fileName, csv) {
                        root.reportExportRequested(fileName, csv);
                    }
                }
                UsersPage {}
            }
        }
    }
}
