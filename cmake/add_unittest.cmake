# CMake file for the add_unittest() helper function.
# Copyright by the NuriaProject under the zlib license. (See LICENSE)

# Adds a unit-test to the project.
#  Usage: add_unittest(NAME <tst_name> NURIA <NuriaX> .. QT .. SOURCES .. RESOURCES .. DEFINES .. EMBED_TARGETS ..)
#  Nuria modules must have Nuria prepended, Qt modules do not.
#  By default, NuriaCore, QtCore and QtTestLib are imported.
#  The unit-test code must be called <tst_name>.cpp
#  Unneeded options can be omitted.
function(add_unittest)
  cmake_parse_arguments(add_unittest "" NAME "QT;NURIA;RESOURCES;SOURCES;DEFINES;EMBED_TARGETS" ${ARGN})
  
  message(STATUS "Adding unit-test ${add_unittest_NAME}")
  
  SET(TEST_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/tests)
  
  # Sources list
  SET(TEST_SOURCES ${TEST_PREFIX}/${add_unittest_NAME}.cpp)
  foreach(file ${add_unittest_SOURCES})
    LIST(APPEND TEST_SOURCES ${TEST_PREFIX}/${file})
  endforeach()
  
  # Fetch sources from embedded targets.
  foreach(embed_target ${add_unittest_EMBED_TARGETS})
    get_target_property(embed_sources ${embed_target} SOURCES)
    LIST(APPEND TEST_SOURCES ${embed_sources})
  endforeach(embed_target)
  
  # Add target
  qt5_add_resources(TEST_RESOURCES ${add_unittest_RESOURCES})
  add_executable(${add_unittest_NAME} ${TEST_SOURCES} ${TEST_RESOURCES})
  
  # Add defines to target
  set_target_properties(${add_unittest_NAME} PROPERTIES COMPILE_DEFINITIONS "${add_unittest_DEFINES}")
  
  # Include directories
  get_target_property(NURIA_INC_DIRS ${add_unittest_NAME} INCLUDE_DIRECTORIES)
  if(NOT NURIA_INC_DIRS)
    SET(NURIA_INC_DIRS "")
  endif()
  
  list(APPEND NURIA_INC_DIRS ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)
  set_target_properties(${add_unittest_NAME} PROPERTIES INCLUDE_DIRECTORIES "${NURIA_INC_DIRS}")
  
  # Link against Qt and Nuria modules and run tria if needed
  target_link_libraries(${add_unittest_NAME} NuriaCore ${add_unittest_NURIA})
  QT5_USE_MODULES(${add_unittest_NAME} Core Test ${add_unittest_QT})
  nuria_tria(${add_unittest_NAME})
  
  # 
  add_test(NAME ${add_unittest_NAME} COMMAND ${add_unittest_NAME})
endfunction(add_unittest)
