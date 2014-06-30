# CMakeLists.txt for the NuriaProject Framework
# This file is licensed under the zlib license. Please refer to 'LICENSE' for
# further details.
cmake_minimum_required(VERSION 2.8.8)
PROJECT(NuriaFramework)
include(cmake/common.cmake)

################################################################################
#  C O N F I G U R A T I O N
# Please see README.md to see available configuration options.
################################################################################

# All modules of the framework in order of building. Their name match the name
# of the directory.
SET(Modules Tria Core Network)

# Create directory structure for output files
# make_directory(${CMAKE_BINARY_DIR}/bin)
# make_directory(${CMAKE_BINARY_DIR}/lib)
# make_directory(${CMAKE_BINARY_DIR}/include)

# Include Core in all modules
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Core/src)

# Add all module directories
foreach(Module ${Modules})
  add_subdirectory(${Module})
endforeach(Module)
