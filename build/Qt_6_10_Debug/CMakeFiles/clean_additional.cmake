# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/DashboardPlugin_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/DashboardPlugin_autogen.dir/ParseCache.txt"
  "CMakeFiles/DashboardPluginplugin_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/DashboardPluginplugin_autogen.dir/ParseCache.txt"
  "CMakeFiles/ModernDashboardQML_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/ModernDashboardQML_autogen.dir/ParseCache.txt"
  "DashboardPlugin_autogen"
  "DashboardPluginplugin_autogen"
  "ModernDashboardQML_autogen"
  "examples/BasicApp/CMakeFiles/DashboardExample_autogen.dir/AutogenUsed.txt"
  "examples/BasicApp/CMakeFiles/DashboardExample_autogen.dir/ParseCache.txt"
  "examples/BasicApp/DashboardExample_autogen"
  )
endif()
