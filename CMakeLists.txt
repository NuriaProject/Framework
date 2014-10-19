# CMakeLists.txt for the NuriaProject Framework
# This file is licensed under the zlib license. Please refer to 'LICENSE' for
# further details.
cmake_minimum_required(VERSION 2.8.8)
PROJECT(NuriaFramework)

cmake_policy(SET CMP0020 NEW)

include(cmake/common.cmake)
include(cmake/nuria_tria.cmake)
include(cmake/add_unittest.cmake)
include(3rdparty/3rdparty.cmake)

################################################################################
#  C O N F I G U R A T I O N
# Please see README.md to see available configuration options.
################################################################################

# All modules of the framework in order of building. Their name match the name
# of the directory.
SET(Modules Tria Core Network Lua Twig)

# Fetch Module List set from outside (overrides above definition)
if(NURIA_MODULES)
  SET(Modules ${NURIA_MODULES})
endif()

# Remove specific Modules (overrides any of the above definitions)
if(NURIA_NO_TRIA)
  LIST(REMOVE_ITEM Modules "Tria")
endif()

if(NURIA_NO_CORE)
  LIST(REMOVE_ITEM Modules "Core")
endif()

if(NURIA_NO_NETWORK)
  LIST(REMOVE_ITEM Modules "Network")
endif()

if(NURIA_NO_LUA)
  LIST(REMOVE_ITEM Modules "Lua")
endif()

if(NURIA_NO_TWIG)
  LIST(REMOVE_ITEM Modules "Twig")
endif()

# Enable C++11
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

# Set location for Nuria modules (in-build)
SET(NURIA_CMAKE_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/cmake/modules")
LIST(APPEND CMAKE_PREFIX_PATH "${NURIA_CMAKE_PREFIX}")

# Enable tests
enable_testing()

# 
LIST(FIND Modules Tria TriaModulePos)
if(NOT TriaModulePos EQUAL -1)
  message(STATUS "Building with Tria (in-source)")
  SET(HasTria 1)
else()
  find_package(tria)
  if(TARGET tria)
    SET(HasTria 1)
    message(STATUS "Building with Tria (imported)")
  else()
    message(STATUS "Building WITHOUT Tria")
  endif()
endif()

# Add all module directories
foreach(Module ${Modules})
  add_subdirectory(${Module})
endforeach(Module)

# 
FIND_PACKAGE(Qt5Core REQUIRED)

# Create directory for configuration files
make_directory(${CMAKE_CURRENT_BINARY_DIR}/config)

# Find qmake(.exe)
if(WIN32)
  SET(QMAKE_EXECUTABLE_NAME qmake.exe)
else()
  SET(QMAKE_EXECUTABLE_NAME qmake)
endif()

# Taken from FindQt.cmake
find_program(QMAKE_EXECUTABLE NAMES ${QMAKE_EXECUTABLE_NAME}
             PATHS "${QT_SEARCH_PATH}/bin" "$ENV{QTDIR}/bin")

# Find the path to Qt configuration files
message(STATUS "Found qmake at ${QMAKE_EXECUTABLE}")
exec_program(${QMAKE_EXECUTABLE} ARGS "-query QT_INSTALL_ARCHDATA" OUTPUT_VARIABLE QMAKE_ARCHPATH)
SET(QMAKE_FEATURE_PATH ${QMAKE_ARCHPATH}/mkspecs/features)

# Generate nuriavars.prf
string(REPLACE ";" " " MODULE_NAMES "${Modules}")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config/nuriavars.prf.in
               ${CMAKE_CURRENT_BINARY_DIR}/config/nuriavars.prf
               @ONLY)

# Install the QMake .prf files
SET(QMAKE_FEATURE_FILES
    ${CMAKE_CURRENT_BINARY_DIR}/config/nuriavars.prf
    ${CMAKE_CURRENT_SOURCE_DIR}/config/nuria.prf
)

INSTALL(FILES ${QMAKE_FEATURE_FILES} DESTINATION ${QMAKE_FEATURE_PATH})

# Generate Framework package
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/install/NuriaFramework/NuriaFrameworkConfig.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/cmake/install/NuriaFramework/NuriaFrameworkConfig.cmake
               @ONLY)

# Install cmake modules for external usage
INSTALL(DIRECTORY cmake/install/ DESTINATION lib/cmake
        PATTERN "*.in" EXCLUDE)
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/cmake/install/NuriaFramework/NuriaFrameworkConfig.cmake DESTINATION lib/cmake/NuriaFramework)

if(HasTria)
  INSTALL(FILES cmake/nuria_tria.cmake cmake/win32_stdlib_include.cmake DESTINATION lib/cmake/tria)
endif()

# Doxygen
include(cmake/doxygen.cmake)
