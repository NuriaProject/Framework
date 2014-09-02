# Doxygen based documentation generator

# Disabled?
if(NURIA_SKIP_DOCS)
  message(STATUS "Documentation generation has been disabled.")
  return()
endif()

# Find doxygen
find_package(Doxygen)
if(NOT DOXYGEN_FOUND)
  message(STATUS "Doxygen not found, no documentation will be generated.")
  return()
endif()

# Add 'docs' target
add_custom_target(
    docs ALL
    COMMAND ${DOXYGEN_EXECUTABLE} contrib/doxygen/Doxyfile
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generating documentation"
)

# 
message(STATUS "Generated documentation can be found in ${CMAKE_SOURCE_DIR}/docs")
message(STATUS "To only generate documentation, run: make docs")
if(NOT UNIX)
  message(STATUS "Documentation will not be installed on this platform")
  return()
endif()

# Add install directive for documentation data on linux
SET(NURIA_DOCS_PATH ${CMAKE_INSTALL_PREFIX}/share/doc/nuriaframework)
message(STATUS "Documentation will be installed to ${NURIA_DOCS_PATH}")

install(
    DIRECTORY ${CMAKE_SOURCE_DIR}/docs/
    DESTINATION ${NURIA_DOCS_PATH}
    CONFIGURATIONS Release
)
