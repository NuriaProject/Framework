# CMakeLists.txt for the NuriaProject Framework
# This file is licensed under the zlib license. Please refer to 'LICENSE' for
# further details.
cmake_minimum_required(VERSION 2.8.8)
PROJECT(NuriaFramework)

include(cmake/common.cmake)
include(cmake/nuria_tria.cmake)
include(cmake/add_unittest.cmake)

################################################################################
#  C O N F I G U R A T I O N
# Please see README.md to see available configuration options.
################################################################################

# All modules of the framework in order of building. Their name match the name
# of the directory.
SET(Modules Tria Core Network Lua Twig)

# Enable C++11
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

# Include Core in all modules
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Core/src)

# Enable tests
enable_testing()

# 
LIST(FIND Modules Tria TriaModulePos)
if(NOT TriaModulePos EQUAL -1)
  message(STATUS "Building with Tria")
  SET(HasTria 1)
else()
  message(STATUS "Building WITHOUT Tria")
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
