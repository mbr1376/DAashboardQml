cmake_minimum_required(VERSION 3.16)
project(DashboardRestApiExample VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Qml Quick QuickControls2)

if(NOT TARGET Dashboard::DashboardPlugin)
    find_package(Dashboard 1.0 CONFIG REQUIRED)
endif()

if(COMMAND qt_policy)
    qt_policy(SET QTP0001 NEW)
endif()

if(NOT DASHBOARD_QML_IMPORT_PATH)
    set(DASHBOARD_QML_IMPORT_PATH "" CACHE PATH
        "QML import root containing the Dashboard/ module")
endif()

if(NOT TARGET DashboardPlugin AND NOT EXISTS "${DASHBOARD_QML_IMPORT_PATH}/Dashboard/qmldir")
    message(FATAL_ERROR
        "Dashboard QML module not found. Set DASHBOARD_QML_IMPORT_PATH to the "
        "directory containing Dashboard/, for example "
        "\"${CMAKE_BINARY_DIR}/qml\" or \"<prefix>/lib/qt6/qml\".")
endif()

qt_add_executable(DashboardRestApiExample src/main.cpp)
set_target_properties(DashboardRestApiExample PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin"
)

set_source_files_properties(qml/Main.qml PROPERTIES QT_RESOURCE_ALIAS Main.qml)
qt_add_qml_module(DashboardRestApiExample
    URI DashboardRestApiExample
    VERSION 1.0
    IMPORT_PATH "${DASHBOARD_QML_IMPORT_PATH}"
    QML_FILES qml/Main.qml
)

target_compile_definitions(DashboardRestApiExample PRIVATE
    DASHBOARD_QML_IMPORT_PATH="${DASHBOARD_QML_IMPORT_PATH}"
)
target_link_libraries(DashboardRestApiExample PRIVATE
    Dashboard::DashboardPlugin
    Qt6::Quick
    Qt6::QuickControls2
)

if(TARGET DashboardPluginplugin)
    add_dependencies(DashboardRestApiExample DashboardPluginplugin)
endif()
