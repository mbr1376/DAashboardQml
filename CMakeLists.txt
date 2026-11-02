cmake_minimum_required(VERSION 3.16)
project(ModernDashboardQML VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Qml Quick QuickControls2 QuickDialogs2 Network)
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

if(COMMAND qt_policy)
    qt_policy(SET QTP0001 NEW)
endif()

set(DASHBOARD_QML_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/qml/Dashboard")

qt_add_library(DashboardPlugin SHARED)
add_library(Dashboard::DashboardPlugin ALIAS DashboardPlugin)

set_source_files_properties(qml/Theme.qml PROPERTIES
    QT_RESOURCE_ALIAS Theme.qml
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(qml/DashboardView.qml PROPERTIES QT_RESOURCE_ALIAS DashboardView.qml)
set_source_files_properties(qml/DashboardBuilder.qml PROPERTIES QT_RESOURCE_ALIAS DashboardBuilder.qml)
set_source_files_properties(qml/DashboardWidget.qml PROPERTIES QT_RESOURCE_ALIAS DashboardWidget.qml)
set_source_files_properties(qml/DashboardChart.qml PROPERTIES QT_RESOURCE_ALIAS DashboardChart.qml)
set_source_files_properties(qml/components/Sidebar.qml PROPERTIES QT_RESOURCE_ALIAS Sidebar.qml)
set_source_files_properties(qml/components/TopBar.qml PROPERTIES QT_RESOURCE_ALIAS TopBar.qml)
set_source_files_properties(qml/components/StatCard.qml PROPERTIES QT_RESOURCE_ALIAS StatCard.qml)
set_source_files_properties(qml/components/DataTable.qml PROPERTIES QT_RESOURCE_ALIAS DataTable.qml)
set_source_files_properties(qml/pages/DashboardPage.qml PROPERTIES QT_RESOURCE_ALIAS DashboardPage.qml)
set_source_files_properties(qml/pages/AnalyticsPage.qml PROPERTIES QT_RESOURCE_ALIAS AnalyticsPage.qml)
set_source_files_properties(qml/pages/ReportsPage.qml PROPERTIES QT_RESOURCE_ALIAS ReportsPage.qml)
set_source_files_properties(qml/pages/UsersPage.qml PROPERTIES QT_RESOURCE_ALIAS UsersPage.qml)

qt_add_qml_module(DashboardPlugin
    URI Dashboard
    VERSION 1.0
    OUTPUT_DIRECTORY "${DASHBOARD_QML_BUILD_DIR}"
    SOURCES
        src/dashboard/dashboarddatamodel.h
        src/dashboarddatamodel.cpp
        src/dashboarddatasource.h
        src/dashboarddatasource.cpp
        src/chartmodels/linechartitem.h
        src/chartmodels/linechartitem.cpp
        src/chartmodels/donuttchartitem.h
        src/chartmodels/donutchartitem.cpp
    QML_FILES
        qml/DashboardView.qml
        qml/DashboardBuilder.qml
        qml/DashboardWidget.qml
        qml/DashboardChart.qml
        qml/Theme.qml
        qml/components/Sidebar.qml
        qml/components/TopBar.qml
        qml/components/StatCard.qml
        qml/components/DataTable.qml
        qml/pages/DashboardPage.qml
        qml/pages/AnalyticsPage.qml
        qml/pages/ReportsPage.qml
        qml/pages/UsersPage.qml
)

set_target_properties(DashboardPlugin PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${DASHBOARD_QML_BUILD_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${DASHBOARD_QML_BUILD_DIR}"
)

target_link_libraries(DashboardPlugin PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::QuickDialogs2
    Qt6::Network
)
target_link_libraries(DashboardPlugin PUBLIC Qt6::Qml)
target_compile_definitions(DashboardPlugin PRIVATE DASHBOARDPLUGIN_LIBRARY)
target_include_directories(DashboardPlugin
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    PRIVATE
        src/dashboard
        src/chartmodels
)

set(DASHBOARD_QML_IMPORT_PATH "${CMAKE_CURRENT_BINARY_DIR}/qml")
add_subdirectory(examples/BasicApp)
add_subdirectory(examples/JsonApp)
add_subdirectory(examples/RestApiApp)

qt_add_executable(ModernDashboardQML src/main.cpp)
set_target_properties(ModernDashboardQML PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_CURRENT_BINARY_DIR}"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_BINARY_DIR}"
    RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_CURRENT_BINARY_DIR}"
    RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL "${CMAKE_CURRENT_BINARY_DIR}"
)

set_source_files_properties(qml/Main.qml PROPERTIES QT_RESOURCE_ALIAS Main.qml)
qt_add_qml_module(ModernDashboardQML
    URI DashboardApp
    VERSION 1.0
    IMPORT_PATH "${CMAKE_CURRENT_BINARY_DIR}/qml"
    QML_FILES qml/Main.qml
)

target_link_libraries(ModernDashboardQML PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)

if(UNIX AND NOT APPLE)
    set_target_properties(DashboardPluginplugin PROPERTIES INSTALL_RPATH "$ORIGIN")
elseif(APPLE)
    set_target_properties(DashboardPluginplugin PROPERTIES INSTALL_RPATH "@loader_path")
endif()

install(TARGETS DashboardPlugin
    EXPORT DashboardTargets
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/Dashboard"
    RUNTIME DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/Dashboard"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/Dashboard"
)
install(TARGETS DashboardPluginplugin
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/Dashboard"
    RUNTIME DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/Dashboard"
)
install(FILES "${DASHBOARD_QML_BUILD_DIR}/qmldir"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/Dashboard"
)
install(FILES "${DASHBOARD_QML_BUILD_DIR}/DashboardPlugin.qmltypes"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/Dashboard"
)
install(FILES
    qml/DashboardView.qml
    qml/DashboardBuilder.qml
    qml/DashboardWidget.qml
    qml/DashboardChart.qml
    qml/Theme.qml
    qml/components/Sidebar.qml
    qml/components/TopBar.qml
    qml/components/StatCard.qml
    qml/components/DataTable.qml
    qml/pages/DashboardPage.qml
    qml/pages/AnalyticsPage.qml
    qml/pages/ReportsPage.qml
    qml/pages/UsersPage.qml
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt6/qml/Dashboard"
)
install(FILES src/dashboard/dashboarddatamodel.h
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/dashboard"
)

configure_package_config_file(
    cmake/DashboardConfig.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/DashboardConfig.cmake"
    INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/Dashboard"
)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/DashboardConfigVersion.cmake"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY SameMajorVersion
)
install(EXPORT DashboardTargets
    FILE DashboardTargets.cmake
    NAMESPACE Dashboard::
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/Dashboard"
)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/DashboardConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/DashboardConfigVersion.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/Dashboard"
)

if(WIN32)
    set_target_properties(ModernDashboardQML PROPERTIES WIN32_EXECUTABLE TRUE)
endif()

if(APPLE)
    set_target_properties(ModernDashboardQML PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_GUI_IDENTIFIER com.learnqt.dashboard.qml
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
    )
endif()
