import QtQuick
import QtTest
import Dashboard

TestCase {
    name: "DynamicDashboard"

    DashboardDataSource {
        id: source
    }

    DashboardDataModel {
        id: cppModel
    }

    ListModel {
        id: hostModel
        ListElement { category: "Online"; sales: 120 }
        ListElement { category: "Retail"; sales: 80 }
    }

    DashboardView {
        id: dashboard
        width: 1200
        height: 800
        dataModel: hostModel
    }

    ReportsPage {
        id: reportsPage
        width: 900
        height: 700
        rows: [
            { category: "Online", sales: 120 },
            { category: "Retail", sales: 80 },
            { category: "Online", sales: 30 }
        ]
    }

    AnalyticsPage {
        id: analyticsPage
        width: 900
        height: 700
        rows: [
            { category: "Online", sales: 120 },
            { category: "Retail", sales: 80 },
            { category: "Online", sales: 30 }
        ]
    }

    SignalSpy {
        id: reportSpy
        target: reportsPage
        signalName: "reportGenerated"
    }

    SignalSpy {
        id: exportSpy
        target: reportsPage
        signalName: "exportRequested"
    }

    function test_jsonArray() {
        verify(source.loadJson('[{"name":"A","value":12},{"name":"B","value":8}]'));
        compare(source.rows.length, 2);
        compare(source.rows[0].name, "A");
        compare(source.rows[1].value, 8);
    }

    function test_jsonEnvelope() {
        verify(source.loadJson('{"data":[{"name":"A","value":12}]}'));
        compare(source.rows.length, 1);
        compare(source.rows[0].value, 12);
    }

    function test_directData() {
        verify(dashboard.setData([{ category: "Custom", sales: 42 }]));
        compare(dashboard.dataRows.length, 1);
        compare(dashboard.dataRows[0].sales, 42);
    }

    function test_csvWithQuotes() {
        verify(source.loadCsv('name,value,note\nAlpha,12,"first, item"\nBeta,8,second'));
        compare(source.rows.length, 2);
        compare(source.rows[0].value, 12);
        compare(source.rows[0].note, "first, item");
    }

    function test_invalidJsonReportsError() {
        verify(!source.loadJson("{broken"));
        verify(source.errorMessage.length > 0);
    }

    function test_hostModelUpdates() {
        verify(source.setSource(hostModel));
        compare(source.rows.length, 2);
        compare(source.rows[0].category, "Online");
        hostModel.append({ category: "Partner", sales: 50 });
        tryCompare(source.rows, "length", 3);
    }

    function test_dashboardDataModelCppApi() {
        verify(cppModel.setRows([
            { category: "Online", sales: 120 },
            { category: "Retail", sales: 80 }
        ]));
        compare(cppModel.count, 2);
        compare(cppModel.rowAt(0).category, "Online");

        var appended = cppModel.appendRow({ category: "Partner", sales: 50 });
        compare(appended, 2);
        compare(cppModel.count, 3);

        verify(cppModel.updateRow(0, { sales: 150 }));
        compare(cppModel.rowAt(0).sales, 150);
        verify(cppModel.removeRow(1));
        compare(cppModel.count, 2);
        verify(!cppModel.removeRow(8));

        verify(cppModel.updateRow(0, { margin: 0.25 }));
        compare(cppModel.rowAt(0).margin, 0.25);
        compare(cppModel.rowAt(0).category, "Online");
    }

    function test_dashboardLayoutCanBeRestored() {
        compare(dashboard.dataRows.length, 2);
        var savedLayout = [{
            id: "restored",
            title: "Restored chart",
            type: "scatter",
            x: 0,
            y: 0,
            w: 6,
            h: 3,
            xField: "category",
            yField: "sales"
        }];
        verify(dashboard.setLayout(savedLayout));
        compare(dashboard.dashboardLayout.length, 1);
        compare(dashboard.dashboardLayout[0].type, "scatter");

        var overlapping = [
            savedLayout[0],
            { id: "overlap", title: "Overlap", type: "bar",
              x: 2, y: 1, w: 4, h: 2, xField: "category", yField: "sales" }
        ];
        verify(!dashboard.setLayout(overlapping));
    }

    function test_analyticsUsesDynamicRows() {
        compare(analyticsPage.rows.length, 3);
        compare(analyticsPage.numericFields[0], "sales");
        compare(analyticsPage.totalValue(), 230);
        compare(analyticsPage.averageValue(), 230 / 3);
        compare(analyticsPage.uniqueValueCount(), 2);
        compare(analyticsPage.largestRows()[0].sales, 120);
    }

    function test_reportsAggregateDynamicRows() {
        compare(reportsPage.reportRows.length, 2);
        compare(reportsPage.reportRows[0].group, "Online");
        compare(reportsPage.reportRows[0].value, 150);
        compare(reportsPage.reportRows[0].records, 2);

        reportsPage.aggregation = "average";
        compare(reportsPage.reportRows[0].value, 75);
        reportsPage.generateReport();
        compare(reportSpy.count, 1);
        compare(reportSpy.signalArguments[0][0].sourceRecordCount, 3);

        reportsPage.exportReport();
        compare(exportSpy.count, 1);
        verify(exportSpy.signalArguments[0][1].indexOf('"Online","75"') >= 0);
    }
}
