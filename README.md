# Modern Dashboard - Qt QML

A modern, dark-themed dashboard application built with **Qt 6 QML/Quick** and **C++**.
Demonstrates professional Qt Quick development with custom Canvas rendering, declarative UI, and Material-inspired design.

## What You'll See

A polished, dark dashboard featuring:
- **Sidebar navigation** with smooth hover effects and diamond logo
- **Dynamic JSON, CSV, REST, and Qt model data sources**
- **Editable dashboard layout** with draggable, resizable, addable, and removable widgets
- **Selectable charts**: line, bar, area, scatter, pie, and donut
- **Data tables** generated from the active data fields
- **4 navigable pages**: Dashboard, Analytics, Reports, Users
- **Fully declarative QML UI** with responsive layouts

## Requirements

- **Qt 6.0+** (Qt Quick, Quick Controls, Quick Dialogs, and Network modules)
- **CMake 3.16+**
- **C++17 or later** compiler (MSVC, GCC, or Clang with MinGW)
- **Windows, Linux, or macOS**

## How to Build & Run

### Build and install the QML module

The reusable module is published as the `Dashboard` QML URI. Build and install it
with the same Qt 6 installation used by the application that will import it:

```bash
cmake -S . -B build -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build build
cmake --install build
```

The module is installed under
`<prefix>/<CMAKE_INSTALL_LIBDIR>/qt6/qml/Dashboard` (for example, `lib64/qt6/qml`
on some Linux systems). Add the parent `qml` directory to the importing
application's QML import path, then use the embeddable `DashboardView` from any
Qt Quick scene:

```qml
import QtQuick
import Dashboard

Window {
    visible: true
    width: 1400
    height: 900

    DashboardView {
        anchors.fill: parent
    }
}
```

For example, set the path in the importing application's C++ entry point:

```cpp
engine.addImportPath("/path/to/prefix/<libdir>/qt6/qml");
```

Replace `<libdir>` with the configured `CMAKE_INSTALL_LIBDIR` value. The module
requires Qt Quick, Qt Quick Controls 2, Qt Quick Dialogs, and Qt Network.

### Dynamic data, charts, and layout editing

The dashboard opens in edit mode when the user selects **Edit layout**. Widgets
can be dragged, resized from their lower-right corner, removed, or added. New
widgets can display a table or line, bar, area, scatter, pie, or donut chart.
Chart fields are selected from the keys in the active data rows.

Data can be loaded in the dashboard UI from JSON/CSV files, pasted as JSON, or
fetched from a REST endpoint. The JSON root may be an array of objects or an
object with a `data` or `rows` array. CSV files must have a header row. REST
requests use GET and optionally accept a Bearer token.

The **Analytics** page derives record counts, totals, averages, unique values,
largest records, and selectable charts from the active dataset. The **Reports**
page groups that dataset by a selected field, calculates sum/average/count/min/
max, supports searching the generated results, and emits CSV for the host to
save. `DashboardView` exposes `reportGenerated(report)` and
`reportExportRequested(fileName, csv)` signals so the host can persist or export
reports using its own storage and file APIs.

The host application can also supply data directly:

```qml
import Dashboard

DashboardView {
    id: dashboard
    dataModel: hostListModel // QML ListModel or a QAbstractItemModel with role names

    onDataLoadFailed: function(message) {
        console.error(message);
    }

    onLayoutChanged: function(layout) {
        // Optional: update the host application's in-memory state.
    }

    onSaveLayoutRequested: function(layout) {
        // Persist this QVariantList/JSON in the host application.
        settings.saveDashboardLayout(layout);
    }
}
```

Alternatively, call `setData(rows)`, `loadJson(text)`, `loadCsv(text)`,
`loadFile(url)`, or `loadRest(url, bearerToken)` on the `DashboardView` object.
Call `setLayout(layout)` to restore the saved layout. Each layout entry has
`id`, `title`, `type`, `x`, `y`, `w`, `h`, `xField`, and `yField` properties.
The host owns persistence: **Save layout** emits `saveLayoutRequested`, while
`layoutChanged` reports edits as they happen.

`examples/BasicApp` is a working host example. It passes a QML `ListModel` into
the module and persists layouts with `QSettings`.

### Run the example consumer application

The `examples/BasicApp` project demonstrates importing the installed module
from a separate Qt Quick application. First build and install the module as
shown above, then configure, build, and run the example:

```bash
cmake -S examples/BasicApp -B build/basic-example \
  -DDASHBOARD_QML_IMPORT_PATH="$HOME/.local/lib/qt6/qml"
cmake --build build/basic-example
./build/basic-example/bin/DashboardExample
```

Set `DASHBOARD_QML_IMPORT_PATH` to the directory that directly contains
`Dashboard/` (use your configured library directory, such as `lib64` if
applicable). The example window shows the embeddable dashboard running inside a
host application's `Window`.

To build the same example against the in-tree module without installing it,
configure the main project and build its example target:

```bash
cmake -S . -B build
cmake --build build --target DashboardExample
./build/examples/BasicApp/bin/DashboardExample
```

### Option 1: Using Qt Creator (Recommended for QML)

1. Open **Qt Creator**
2. Click **File → Open File or Project**
3. Navigate to `qt-qml/CMakeLists.txt` and open it
4. Select your Qt 6 kit (MinGW 64-bit or similar)
5. Click **Configure Project**
6. Press **Ctrl+R** (or click the green play button) to build and run

### Option 2: Using VS Code with CMake Extension

1. Open this folder (`qt-qml`) in **Visual Studio Code**
2. Install the **CMake Tools** extension if you haven't already
3. Press **Ctrl+Shift+P** (or **Cmd+Shift+P** on macOS) and select:
   - **CMake: Configure** (first time only)
   - **CMake: Build**
4. Run the application:
   - Press **F5** or use **CMake: Run Without Debugging**

### Option 3: Command Line Build

```bash
# From the qt-qml directory
mkdir build
cd build
cmake ..
cmake --build .

# Run the executable
./ModernDashboardQML          # Linux/macOS
ModernDashboardQML.exe        # Windows
```

## Project Structure

```
qt-qml/
├── CMakeLists.txt              # Plugin module and standalone app configuration
├── README.md                   # This file
├── qml/
│   ├── Main.qml                # Standalone application window
│   ├── DashboardView.qml       # Embeddable Dashboard root item
│   ├── DashboardBuilder.qml    # Data import and widget layout editor
│   ├── DashboardWidget.qml     # Resizable dashboard widget
│   ├── DashboardChart.qml      # Dynamic chart renderer
│   ├── Theme.qml               # Color & font definitions (Singleton)
│   ├── qmldir                  # QML module definition
│   ├── components/
│   │   ├── Sidebar.qml         # Left navigation panel
│   │   ├── TopBar.qml          # Top breadcrumb bar
│   │   ├── StatCard.qml        # Animated stat card (Canvas API)
│   │   └── DataTable.qml       # Data table with status pills
│   └── pages/
│       ├── DashboardPage.qml   # Main dashboard with cards & charts
│       ├── AnalyticsPage.qml   # Dynamic analytics derived from active data
│       ├── ReportsPage.qml     # Dynamic grouped report and CSV export
│       └── UsersPage.qml       # Users page placeholder
├── examples/
│   └── BasicApp/              # Separate app importing DashboardView
│       ├── CMakeLists.txt
│       ├── qml/Main.qml
│       └── src/main.cpp
├── src/
│   ├── main.cpp                # Application entry point
│   ├── dashboarddatasource.h/.cpp # JSON, CSV, REST, and Qt model data
│   └── chartmodels/
│       ├── linechartitem.h/.cpp    # C++ line chart with QPainter
│       └── donutchartitem.h/.cpp   # C++ donut chart with QPainter
└── build/                      # Generated build files
```

---

## 🎨 Quick Customization Guide

This guide shows you **exactly where to make changes** to customize the dashboard.
All examples include **commented-out alternatives** you can uncomment to see the effects.

---

### 🌟 **MOST IMPACTFUL**: Switch Complete Themes

Want to **dramatically change the entire look** with one simple edit? We've created **6 complete color themes** with vastly different visual styles!

Each theme changes:
- ✨ Background colors (dramatically different!)
- 🎨 Sidebar appearance and gradients
- 🔲 Card and button styles
- 🖱️ Hover effects
- 📊 All accent colors and borders

#### 📁 **Change the Theme Colors**

**File:** [`qml/Theme.qml`](qml/Theme.qml#L1-L140)

1. Open [`qml/Theme.qml`](qml/Theme.qml)
2. Find the **THEME 1: DARK BLUE PURPLE** section (currently active)
3. **Comment out** all the `readonly property color` lines in THEME 1
4. **Uncomment** the entire theme section you want (THEME 2, 3, 4, 5, or 6)
5. Save the file — **no rebuild needed!** Run the app to see changes instantly

**Available themes:**

- **THEME 1: DARK BLUE PURPLE** (Default) — Original dark blue/purple
- **THEME 2: PURPLE BRANDING** (🟣) — Vibrant purple/violet branding
- **THEME 3: OCEAN BREEZE** (🌊) — Cool blue/cyan professional
- **THEME 4: NORD DARK** (🏔️) — Muted, soft Nord palette
- **THEME 5: CYBERPUNK** (⚡) — Neon futuristic with high contrast
- **THEME 6: FOREST** (🌲) — Earthy green nature theme

**Example change:**
```qml
// Comment out THEME 1 (wrap in /* ... */ )
/*
readonly property color background:    "#1a1a2e"
readonly property color sidebarTop:    "#1e1e2e"
// ... rest of THEME 1 ...
*/

// Uncomment THEME 5 (remove /* and */ )
readonly property color background:    "#0a0e27"
readonly property color sidebarTop:    "#1a1a2e"
readonly property color sidebarBottom: "#16213e"
// ... rest of THEME 5 ...
```

**✨ QML Advantage:** Changes appear **instantly** when you run the app — no rebuild required!

---

### 1️⃣ Change the Global Font

#### **File:** [`src/main.cpp`](src/main.cpp#L30-L75)

**What to do:**
1. Open [`src/main.cpp`](src/main.cpp)
2. Find the **OPTION 1: Segoe UI** section (around line 30)
3. **Comment out** OPTION 1
4. **Uncomment** one of the 7 font options provided:
   - **Segoe UI** (Windows default)
   - **Inter** (Web-inspired, crisp)
   - **Roboto** (Google Material Design)
   - **SF Pro Text** (Apple-style)
   - **Helvetica Neue** (Classic)
   - **Poppins** (Modern & geometric)
   - **JetBrains Mono** (Monospace for tech dashboards)
5. Save and **rebuild** (fonts are set at application startup)

**Example:**
```cpp
// Comment out:
// QFont appFont("Segoe UI", 13);

// Uncomment:
QFont appFont("JetBrains Mono", 11);
appFont.setStyleStrategy(QFont::PreferAntialias);
app.setFont(appFont);
```

---

### 2️⃣ Change Window Size

#### **File:** [`qml/Main.qml`](qml/Main.qml#L26-L50)

**What to do:**
1. Open [`qml/Main.qml`](qml/Main.qml)
2. Find the **OPTION 1: Wide HD (1400x900)** section (around line 26)
3. **Comment out** the current `width` and `height` lines
4. **Uncomment** one of the 4 window size options:
   - **Wide HD (1400x900)** — Default, spacious
   - **Standard HD (1280x800)** — Balanced
   - **Compact (1024x768)** — Smaller screens
   - **Full HD (1600x950)** — Large desktop
5. Save and run — changes apply instantly!

---

### 3️⃣ Change Stat Card Data

#### **File:** [`qml/pages/DashboardPage.qml`](qml/pages/DashboardPage.qml#L32-L166)

In the first `RowLayout`, you'll find 4 `StatCard` components. **Commented-out examples are provided** for different use cases.

**What to do:**
1. Open [`qml/pages/DashboardPage.qml`](qml/pages/DashboardPage.qml)
2. Find the **Stat Cards Row** section (around line 32)
3. **Option A:** Directly edit the existing StatCard properties
4. **Option B:** Comment out the entire `RowLayout` and uncomment one of these alternatives:
   - **OPTION 2:** E-Commerce Dashboard (orders, products, return rate, satisfaction)
   - **OPTION 3:** Server Monitoring (uptime, response time, error rate, connections)
   - **OPTION 4:** Marketing Campaign (reach, CTR, leads, ROI)

**StatCard properties:**
```qml
StatCard {
    Layout.fillWidth: true
    Layout.preferredHeight: 180
    iconChar: "\u2603"          // Unicode character/emoji
    title: "Total Users"        // Card label
    value: "12,458"             // Main metric
    change: "+12.5%"            // Change indicator
    positive: true              // Green (true) or red (false)
    accentColor: Theme.accentBlue
}
```

**Icon characters you can use:**
- `"\u2603"` ☃ Snowman
- `"\u2605"` ★ Star
- `"\u25CE"` ◎ Target
- `"\u2713"` ✓ Checkmark
- `"\u2717"` ✗ X Mark
- `"\u2630"` ☰ Menu
- `"\u2665"` ♥ Heart
- `"\u25B2"` ▲ Up triangle
- Or any emoji!

---

### 4️⃣ Change Chart Data

#### **File:** [`qml/pages/DashboardPage.qml`](qml/pages/DashboardPage.qml#L168-L258)

Charts are defined in the **Charts Row** section. **Commented alternatives show different data patterns**.

**Line Chart (Performance Overview):**

1. Open [`qml/pages/DashboardPage.qml`](qml/pages/DashboardPage.qml)
2. Find the `LineChartItem` component (around line 115)
3. Replace the `dataPoints` array with your own values
4. Update the `xLabels` array to match
5. **Uncomment one of the 4 alternative patterns** to see examples:
   - **OPTION 2:** Weekly Sales Pattern (7 days)
   - **OPTION 3:** Server Traffic (24-hour)
   - **OPTION 4:** Quarterly Revenue Growth

**Example:**
```qml
LineChartItem {
    anchors.fill: parent
    // ... anchors ...
    dataPoints: [120, 145, 160, 155, 180, 195, 210]
    xLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    lineColor: Theme.accentGreen
}
```

**Donut Chart (Category Breakdown):**

1. Find the `DonutChartItem` component (around line 155)
2. Replace the `slices` array with your own data
3. **Uncomment one of the 4 alternative patterns**:
   - **OPTION 2:** Traffic Sources (organic, direct, social, email, referral)
   - **OPTION 3:** Server Resource Usage (CPU, memory, disk, network)
   - **OPTION 4:** Customer Demographics (age groups)

**Example:**
```qml
DonutChartItem {
    anchors.fill: parent
    // ... anchors ...
    slices: [
        { label: "Organic Search", value: 42, color: "#3498db" },
        { label: "Direct",         value: 28, color: "#2ecc71" },
        { label: "Social Media",   value: 18, color: "#f39c12" },
        { label: "Email",          value: 8,  color: "#e74c3c" },
        { label: "Referral",       value: 4,  color: "#9b59b6" }
    ]
}
```

---

### 5️⃣ Change Table Data

#### **File:** [`qml/pages/DashboardPage.qml`](qml/pages/DashboardPage.qml#L260-L395)

The data table is in the **Recent Transactions Table** section. **Alternative datasets are commented out** for different use cases.

**What to do:**
1. Open [`qml/pages/DashboardPage.qml`](qml/pages/DashboardPage.qml)
2. Find the `DataTable` component (around line 185)
3. **Option A:** Edit the existing `rows` array directly
4. **Option B:** Comment out the entire `DataTable` and uncomment one of these:
   - **OPTION 2:** E-Commerce Orders Table
   - **OPTION 3:** Server Logs Table (event monitoring)
   - **OPTION 4:** User Activity Log
   - **OPTION 5:** Product Inventory

**Row format:**
```qml
rows: [
    { id: "#1001", name: "Alice Johnson", status: "Completed", amount: "$2,450.00", date: "2026-02-07" },
    // ... more rows ...
]
```

**Status colors** (automatic):
- **"Completed"** → Green pill
- **"Pending"** → Orange pill
- **"Failed"** → Red pill

---

### 6️⃣ Add a New Navigation Page

#### **Files:** [`qml/pages/`](qml/pages/) + [`qml/Main.qml`](qml/Main.qml#L60-L85) + [`qml/components/Sidebar.qml`](qml/components/Sidebar.qml#L35-L42)

**Steps:**

1. **Create the QML page file:**
   - Create `qml/pages/SettingsPage.qml`
   - Use [`AnalyticsPage.qml`](qml/pages/AnalyticsPage.qml) as a template
   - Define your page content

2. **Add to the StackLayout:**
   - Open [`qml/Main.qml`](qml/Main.qml)
   - Find the `StackLayout` component (around line 60)
   - Add your page: `SettingsPage {}`

3. **Add navigation item:**
   - Open [`qml/components/Sidebar.qml`](qml/components/Sidebar.qml)
   - Find the `navModel` array (around line 35)
   - Add: `{ icon: "\u2699", text: "Settings" }`

4. **Add breadcrumb label:**
   - Open [`qml/Main.qml`](qml/Main.qml)
   - Find the `pageNames` array (around line 35)
   - Add: `"Settings  /  Preferences"`

**Example `SettingsPage.qml`:**
```qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "transparent"
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        
        Text {
            text: "Settings Page"
            color: Theme.textPrimary
            font.pixelSize: 24
            font.bold: true
        }
        
        // Your settings UI here
    }
}
```

---

### 7️⃣ Modify the Sidebar Navigation

#### **File:** [`qml/components/Sidebar.qml`](qml/components/Sidebar.qml#L35-L42)

**What to do:**
1. Open [`qml/components/Sidebar.qml`](qml/components/Sidebar.qml)
2. Find the `navModel` array (around line 35)
3. Add, remove, or reorder navigation items
4. Each item has an `icon` (Unicode character) and `text` (label)

**Example:**
```qml
property var navModel: [
    { icon: "\u25A0", text: "Dashboard" },
    { icon: "\u25B2", text: "Analytics" },
    { icon: "\u2605", text: "Favorites" },    // NEW
    { icon: "\u2630", text: "Reports" },
    { icon: "\u2699", text: "Settings" }      // NEW
]
```

**Remember:** Update [`qml/Main.qml`](qml/Main.qml) to add corresponding pages and breadcrumb labels!

---

## 🏗️ Architecture Notes

### QML vs Widgets: Why QML for Dashboards?

This QML version differs from the Widgets version:
- ✅ **Declarative UI** — Define what you want, not how to build it
- ✅ **Live reload** — Changes appear instantly without rebuild (Qt Creator)
- ✅ **Modern animations** — Built-in property animations
- ✅ **Touch-friendly** — Great for tablets and touch displays
- ✅ **Separation of concerns** — UI in QML, logic in C++

### Key Qt Quick Concepts Demonstrated

- **QML Singletons:** `Theme.qml` provides global color access
- **Layouts:** `RowLayout`, `ColumnLayout` for responsive design
- **Canvas API:** 2D drawing in `StatCard.qml`
- **QQuickPaintedItem:** C++ custom painting exposed to QML (charts)
- **Signal handling:** `onNavigationChanged` for page switching
- **Property bindings:** Automatic UI updates when data changes
- **ListModel:** Dynamic data for tables and lists

### C++ and QML Integration

- **`main.cpp`:** Sets up the QML engine and registers C++ types
- **`linechartitem.cpp`:** C++ chart rendered with QPainter, used in QML
- **`donutchartitem.cpp`:** C++ donut chart exposed to QML
- **`Theme.qml`:** QML singleton for centralized styling

---

## 📝 Troubleshooting

### "Qt not found" during CMake configuration

**Solution:** Set the `CMAKE_PREFIX_PATH` environment variable to your Qt installation:
```bash
# Windows (PowerShell)
$env:CMAKE_PREFIX_PATH = "C:\Qt\6.10.1\mingw_64"

# Linux/macOS
export CMAKE_PREFIX_PATH=/home/user/Qt/6.10.1/gcc_64
```

### Theme changes not appearing

**Solution:** Make sure you **uncommented the entire theme block** and commented out all other themes. Only ONE theme should be active at a time in [`qml/Theme.qml`](qml/Theme.qml).

### Fonts look different than expected

**Solution:** 
1. Check that the font is installed on your system
2. Use `QFontDatabase::families()` to list available fonts
3. Rebuild after changing [`src/main.cpp`](src/main.cpp)

### Charts not rendering

**Solution:**
- Ensure `dataPoints` array has at least 2 values
- Check that all colors are valid hex codes (e.g., `"#3498db"`)
- For donut charts, ensure slice values sum to a positive number

### QML warnings about "Cannot assign to non-existent property"

**Solution:** Check that all property names match exactly (case-sensitive). Common mistakes:
- `accentColor` vs `accentcolor`
- `dataPoints` vs `datapoints`

---

## 🎓 Learning Path

If you're new to Qt Quick/QML, explore the code in this order:

1. **Start here:** [`qml/Main.qml`](qml/Main.qml) — Window structure and layout
2. **Then:** [`qml/Theme.qml`](qml/Theme.qml) — Singleton pattern for global properties
3. **Simple component:** [`qml/components/TopBar.qml`](qml/components/TopBar.qml) — Basic QML component
4. **Canvas rendering:** [`qml/components/StatCard.qml`](qml/components/StatCard.qml) — 2D drawing API
5. **C++ integration:** [`src/chartmodels/linechartitem.cpp`](src/chartmodels/linechartitem.cpp) — QPainter in QML
6. **Complex page:** [`qml/pages/DashboardPage.qml`](qml/pages/DashboardPage.qml) — Combining components

Each file has **extensive comments** explaining QML concepts and best practices.

---

## 🔄 QML Live Reload (Qt Creator)

One of QML's best features is **instant reload**! In Qt Creator:

1. Run your app normally
2. Edit any `.qml` file (colors, text, layout)
3. **Save the file** (Ctrl+S)
4. Changes appear **instantly** in the running app — no rebuild!

**Note:** Changes to C++ files (`.cpp`, `.h`) still require a rebuild.

---

## 📊 Customization Comparison

| Feature | QML Project | Widgets Project |
|---------|-------------|-----------------|
| **Theme switching** | Edit `Theme.qml` (instant) | Edit `.qss` + rebuild |
| **Font changes** | Edit `main.cpp` + rebuild | Edit `main.cpp` + rebuild |
| **Window size** | Edit `Main.qml` (instant) | Edit `mainwindow.cpp` + rebuild |
| **Card/Chart data** | Edit `DashboardPage.qml` (instant) | Edit `mainwindow.cpp` + rebuild |
| **Add pages** | Create `.qml` file (instant) | Create `.cpp/.h` + rebuild |
| **Live reload** | ✅ Yes (Qt Creator) | ❌ No |

**Winner for rapid prototyping:** QML! Make changes and see them instantly.

---

## 📄 License

MIT — Free to use in personal and commercial projects.

---

## 🔗 Related Projects

- **C++ Widgets version:** [`qt-widgets-cpp/`](../qt-widgets-cpp/) — Traditional Qt Widgets
- **PySide6 version:** [`qt-widgets-pyside/`](../qt-widgets-pyside/) — Python port with identical UI

---

**Happy coding! 🚀** If you make something cool with this template, feel free to share it!
