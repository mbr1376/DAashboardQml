// DashboardPage.qml - Main dashboard overview page
//
// Displays the primary dashboard with:
//   - 4 stat cards (Total Users, Revenue, Active Sessions, Conversion Rate)
//   - Performance Overview line chart + Category Breakdown donut chart
//   - Recent Transactions data table
//
// CUSTOMIZATION:
//   - Edit the StatCard properties to show your own metrics
//   - Change LineChartItem dataPoints and xLabels for different chart data
//   - Change DonutChartItem slices for different category breakdowns
//   - Edit the DataTable rows for different transaction data

import QtQuick
import QtQuick.Layouts

Flickable {
    id: dashboardPage
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
        // Stat Cards Row
        // CUSTOMIZATION: Change icon, title, value, change, and color
        // ============================================================
        /*
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            StatCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                iconChar: "\u2603"
                title: "Total Users"
                value: "12,458"
                change: "+12.5%"
                positive: true
                accentColor: Theme.accentBlue
            }

            StatCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                iconChar: "\u2605"
                title: "Revenue"
                value: "$45,890"
                change: "+8.2%"
                positive: true
                accentColor: Theme.accentGreen
            }

            StatCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                iconChar: "\u25CE"
                title: "Active Sessions"
                value: "892"
                change: "-2.1%"
                positive: false
                accentColor: Theme.accentOrange
            }

            StatCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                iconChar: "\u25C8"
                title: "Conversion Rate"
                value: "3.24%"
                change: "+0.5%"
                positive: true
                accentColor: Theme.accentRed
            }
        }
        */

        // ============================================================
        // 💡ALTERNATIVE STAT CARD SETS (Uncomment to use)
        // ============================================================
        // You can replace the StatCard row above with any of the sets below.
        // Simply comment out the active row and uncomment one of these.
        // ============================================================

        // === OPTION 2: E-Commerce Dashboard ===
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u2630"; title: "Total Orders"
                value: "3,847"; change: "+15.3%"; positive: true
                accentColor: Theme.accentBlue
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u25A0"; title: "Products Sold"
                value: "18,924"; change: "+22.1%"; positive: true
                accentColor: Theme.accentGreen
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u2717"; title: "Return Rate"
                value: "2.4%"; change: "-0.8%"; positive: true
                accentColor: Theme.accentOrange
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u2665"; title: "Customer Satisfaction"
                value: "94%"; change: "+1.2%"; positive: true
                accentColor: Theme.accentRed
            }
        }

        /*
        // === OPTION 3: Server Monitoring Dashboard ===
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u25B2"; title: "Uptime"
                value: "99.98%"; change: "+0.02%"; positive: true
                accentColor: Theme.accentGreen
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u25BC"; title: "Response Time"
                value: "124ms"; change: "-15ms"; positive: true
                accentColor: Theme.accentBlue
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u25C6"; title: "Error Rate"
                value: "0.02%"; change: "-0.01%"; positive: true
                accentColor: Theme.accentOrange
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u25A1"; title: "Active Connections"
                value: "1,284"; change: "+245"; positive: true
                accentColor: Theme.accentPurple
            }
        }
        */

        /*
        // === OPTION 4: Marketing Campaign Dashboard ===
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u2600"; title: "Campaign Reach"
                value: "89.5K"; change: "+32.7%"; positive: true
                accentColor: Theme.accentBlue
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u2713"; title: "Click-Through Rate"
                value: "4.8%"; change: "+1.2%"; positive: true
                accentColor: Theme.accentGreen
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u270E"; title: "Leads Generated"
                value: "2,147"; change: "+18.5%"; positive: true
                accentColor: Theme.accentOrange
            }
            StatCard {
                Layout.fillWidth: true; Layout.preferredHeight: 180
                iconChar: "\u2605"; title: "ROI"
                value: "340%"; change: "+45%"; positive: true
                accentColor: Theme.accentRed
            }
        }
        */

        // ============================================================
        // Charts Row - Line/Area Chart + Donut Chart
        // ============================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            // --- Performance Overview (Line/Area Chart) ---
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 3   // stretch factor
                Layout.preferredHeight: 350
                radius: 15
                color: Theme.card
                border.color: Theme.border
                border.width: 1

                Text {
                    id: lineChartTitle
                    text: "Performance Overview"
                    color: Theme.textPrimary
                    font { pixelSize: 15; bold: true; family: Theme.fontFamily }
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 15
                    anchors.leftMargin: 25
                }

                // CUSTOMIZATION: Change dataPoints values and xLabels
                // === OPTION 1: Sample Data ===
                LineChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 5
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 10
                    dataPoints: [45, 52, 48, 68, 72, 65, 78, 85, 82, 91, 88, 95]
                    xLabels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                              "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                    lineColor: Theme.accentBlue
                }

                // ============================================================
                // 💡 ALTERNATIVE LINE CHART DATA SETS (Uncomment to use)
                // ============================================================
                // Replace dataPoints/xLabels above with any of the patterns below
                // ============================================================

                // === OPTION 2: Weekly Sales Pattern ===
                /*
                LineChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 5
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 10
                    dataPoints: [120, 145, 160, 155, 180, 195, 210]
                    xLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                    lineColor: Theme.accentGreen
                }
                */

                /*
                // === OPTION 3: Server Traffic (24-hour) ===
                LineChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 5
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 10
                    dataPoints: [20, 18, 15, 12, 10, 15, 25, 45, 65, 75, 70, 85,
                                    90, 88, 80, 75, 82, 95, 88, 70, 55, 40, 30, 25]
                    xLabels: ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11",
                                    "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
                    lineColor: Theme.accentOrange
                }
                */

                /*
                // === OPTION 4: Quarterly Revenue Growth ===
                LineChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 5
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 10

                    dataPoints: [250, 320, 450, 580]
                    xLabels: ["Q1 2025", "Q2 2025", "Q3 2025", "Q4 2025"]
                    lineColor: Theme.accentPurple
                }
                */
            }

            // --- Category Breakdown (Donut Chart) ---
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 2   // stretch factor
                Layout.preferredHeight: 350
                radius: 15
                color: Theme.card
                border.color: Theme.border
                border.width: 1

                Text {
                    text: "Category Breakdown"
                    color: Theme.textPrimary
                    font { pixelSize: 15; bold: true; family: Theme.fontFamily }
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 15
                    anchors.leftMargin: 25
                }

                // CUSTOMIZATION: Change slice labels, values, and colors
                // === OPTION 1: Electronics ===
                DonutChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 15
                    slices: [
                        { label: "Electronics",  value: 35, color: "#3498db" },
                        { label: "Clothing",     value: 25, color: "#2ecc71" },
                        { label: "Food & Drink", value: 20, color: "#f39c12" },
                        { label: "Services",     value: 12, color: "#e74c3c" },
                        { label: "Other",         value: 8, color: "#9b59b6" }
                    ]
                }

                // ============================================================
                // 💡 ALTERNATIVE DONUT CHART DATA SETS (Uncomment to use)
                // ============================================================
                // Replace the slices array above with any pattern below
                // ============================================================

                // === OPTION 2: Traffic Sources ===
                /*
                DonutChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 15



                    slices: [
                        { label: "Organic Search", value: 42, color: "#3498db" },
                        { label: "Direct",         value: 28, color: "#2ecc71" },
                        { label: "Social Media",   value: 18, color: "#f39c12" },
                        { label: "Email",          value: 8,  color: "#e74c3c" },
                        { label: "Referral",       value: 4,  color: "#9b59b6" }
                    ]
                }
                */


                /*
                // === OPTION 3: Server Resource Usage ===
                DonutChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 15


                    slices: [
                        { label: "CPU",     value: 45, color: "#e74c3c" },
                        { label: "Memory",  value: 30, color: "#f39c12" },
                        { label: "Disk",    value: 15, color: "#3498db" },
                        { label: "Network", value: 10, color: "#2ecc71" }
                    ]
                }

                */

                /*
                // === OPTION 4: Customer Demographics ===
                DonutChartItem {
                    anchors.fill: parent
                    anchors.topMargin: 45
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 15

                    slices: [
                        { label: "18-24", value: 15, color: "#9b59b6" },
                        { label: "25-34", value: 35, color: "#3498db" },
                        { label: "35-44", value: 28, color: "#2ecc71" },
                        { label: "45-54", value: 15, color: "#f39c12" },
                        { label: "55+",   value: 7,  color: "#e74c3c" }
                    ]
                }

                */
            }
        }

        // ============================================================
        // Recent Transactions Table
        // CUSTOMIZATION: Edit the rows array with your own data
        // ============================================================
        DataTable {
            Layout.fillWidth: true
            title: "Recent Transactions"
            columns: ["ID", "Name", "Status", "Amount", "Date"]
            statusColumn: 2
            rows: [
                { id: "#1001", name: "Alice Johnson",   status: "Completed", amount: "$2,450.00", date: "2026-02-07" },
                { id: "#1002", name: "Bob Martinez",    status: "Pending",   amount: "$1,890.50", date: "2026-02-06" },
                { id: "#1003", name: "Carol Williams",  status: "Completed", amount: "$3,200.00", date: "2026-02-06" },
                { id: "#1004", name: "David Kim",       status: "Failed",    amount: "$450.75",   date: "2026-02-05" },
                { id: "#1005", name: "Eva Chen",        status: "Completed", amount: "$5,100.00", date: "2026-02-05" },
                { id: "#1006", name: "Frank O'Brien",   status: "Pending",   amount: "$980.25",   date: "2026-02-04" },
                { id: "#1007", name: "Grace Nakamura",  status: "Completed", amount: "$1,750.00", date: "2026-02-04" },
                { id: "#1008", name: "Henry Patel",     status: "Failed",    amount: "$320.00",   date: "2026-02-03" },
                { id: "#1009", name: "Iris Andersson",  status: "Completed", amount: "$4,600.00", date: "2026-02-03" },
                { id: "#1010", name: "James Wilson",    status: "Pending",   amount: "$2,100.50", date: "2026-02-02" }
            ]
        }

        // ============================================================
        // 💡 ALTERNATIVE TABLE DATA SETS (Uncomment to use)
        // ============================================================
        // You can replace the DataTable above with any of these variations.
        // Simply comment out the active table and uncomment one below.
        // ============================================================

        /*
        // === OPTION 2: E-Commerce Orders Table ===
        DataTable {
            Layout.fillWidth: true
            title: "Recent Orders"
            columns: ["Order ID", "Customer", "Status", "Total", "Date"]
            statusColumn: 2
            rows: [
                { id: "#ORD-2401", name: "Sarah Miller",     status: "Completed", amount: "$1,249.99", date: "2026-02-07" },
                { id: "#ORD-2402", name: "Tom Anderson",     status: "Pending",   amount: "$879.50",   date: "2026-02-07" },
                { id: "#ORD-2403", name: "Lucy Brown",       status: "Completed", amount: "$2,150.00", date: "2026-02-06" },
                { id: "#ORD-2404", name: "Mike Davis",       status: "Failed",    amount: "$450.00",   date: "2026-02-06" },
                { id: "#ORD-2405", name: "Emma Wilson",      status: "Completed", amount: "$3,890.00", date: "2026-02-05" },
                { id: "#ORD-2406", name: "Chris Lee",        status: "Pending",   amount: "$690.25",   date: "2026-02-05" },
                { id: "#ORD-2407", name: "Olivia Taylor",    status: "Completed", amount: "$1,540.00", date: "2026-02-04" },
                { id: "#ORD-2408", name: "Daniel Martinez",  status: "Completed", amount: "$950.75",   date: "2026-02-04" },
                { id: "#ORD-2409", name: "Sophia Garcia",    status: "Failed",    amount: "$220.00",   date: "2026-02-03" },
                { id: "#ORD-2410", name: "James Rodriguez",  status: "Pending",   amount: "$1,780.50", date: "2026-02-03" }
            ]
        }
        */

        /*
        // === OPTION 3: Server Logs Table ===
        DataTable {
            Layout.fillWidth: true
            title: "Recent Server Events"
            columns: ["Event ID", "Server", "Status", "Response Time", "Timestamp"]
            statusColumn: 2
            rows: [
                { id: "EVT-8801", name: "api-server-01",  status: "Completed", amount: "145ms", date: "2026-02-07 14:23" },
                { id: "EVT-8802", name: "web-server-03",  status: "Completed", amount: "89ms",  date: "2026-02-07 14:22" },
                { id: "EVT-8803", name: "db-server-02",   status: "Pending",   amount: "320ms", date: "2026-02-07 14:21" },
                { id: "EVT-8804", name: "api-server-02",  status: "Failed",    amount: "5420ms",date: "2026-02-07 14:20" },
                { id: "EVT-8805", name: "web-server-01",  status: "Completed", amount: "72ms",  date: "2026-02-07 14:19" },
                { id: "EVT-8806", name: "cache-server",   status: "Completed", amount: "12ms",  date: "2026-02-07 14:18" },
                { id: "EVT-8807", name: "api-server-03",  status: "Pending",   amount: "890ms", date: "2026-02-07 14:17" },
                { id: "EVT-8808", name: "db-server-01",   status: "Completed", amount: "210ms", date: "2026-02-07 14:16" },
                { id: "EVT-8809", name: "web-server-02",  status: "Completed", amount: "95ms",  date: "2026-02-07 14:15" },
                { id: "EVT-8810", name: "api-server-01",  status: "Failed",    amount: "8900ms",date: "2026-02-07 14:14" }
            ]
        }
        */

        /*
        // === OPTION 4: User Activity Log ===
        DataTable {
            Layout.fillWidth: true
            title: "Recent User Activity"
            columns: ["User ID", "Username", "Status", "Action", "Time"]
            statusColumn: 2
            rows: [
                { id: "USR-501", name: "john.doe",       status: "Completed", amount: "Login",       date: "14:30:15" },
                { id: "USR-502", name: "jane.smith",     status: "Completed", amount: "File Upload", date: "14:28:42" },
                { id: "USR-503", name: "bob.johnson",    status: "Pending",   amount: "Data Export", date: "14:25:10" },
                { id: "USR-504", name: "alice.williams", status: "Failed",    amount: "Login",       date: "14:22:55" },
                { id: "USR-505", name: "charlie.brown",  status: "Completed", amount: "Profile Edit",date: "14:20:33" },
                { id: "USR-506", name: "diana.prince",   status: "Completed", amount: "Logout",      date: "14:18:20" },
                { id: "USR-507", name: "eve.adams",      status: "Pending",   amount: "Report Gen",  date: "14:15:47" },
                { id: "USR-508", name: "frank.castle",   status: "Completed", amount: "Login",       date: "14:12:11" },
                { id: "USR-509", name: "grace.hopper",   status: "Completed", amount: "API Call",    date: "14:10:05" },
                { id: "USR-510", name: "henry.ford",     status: "Failed",    amount: "File Upload", date: "14:08:30" }
            ]
        }
        */

        /*
        // === OPTION 5: Product Inventory ===
        DataTable {
            Layout.fillWidth: true
            title: "Product Inventory Status"
            columns: ["SKU", "Product Name", "Status", "Stock", "Last Updated"]
            statusColumn: 2
            rows: [
                { id: "SKU-A101", name: "Wireless Mouse",      status: "Completed", amount: "450 units", date: "2026-02-07" },
                { id: "SKU-A102", name: "USB-C Cable",         status: "Completed", amount: "1200 units",date: "2026-02-07" },
                { id: "SKU-A103", name: "Laptop Stand",        status: "Pending",   amount: "85 units",  date: "2026-02-06" },
                { id: "SKU-A104", name: "Mechanical Keyboard", status: "Failed",    amount: "12 units",  date: "2026-02-06" },
                { id: "SKU-A105", name: "Webcam HD",           status: "Completed", amount: "320 units", date: "2026-02-05" },
                { id: "SKU-A106", name: "Headphone Stand",     status: "Pending",   amount: "95 units",  date: "2026-02-05" },
                { id: "SKU-A107", name: "Monitor 27\"",        status: "Completed", amount: "145 units", date: "2026-02-04" },
                { id: "SKU-A108", name: "Desk Lamp LED",       status: "Completed", amount: "680 units", date: "2026-02-04" },
                { id: "SKU-A109", name: "Cable Organizer",     status: "Failed",    amount: "3 units",   date: "2026-02-03" },
                { id: "SKU-A110", name: "External SSD 1TB",    status: "Pending",   amount: "210 units", date: "2026-02-03" }
            ]
        }
        */

        // Bottom spacer
        Item { Layout.preferredHeight: 10 }
    }
}
