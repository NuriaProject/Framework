# CMake file for the nuria_tria() helper function.
# Copyright by the NuriaProject under the zlib license. (See LICENSE)

include(${CMAKE_CURRENT_LIST_DIR}/win32_stdlib_include.cmake)

# Runs tria on all C++ header-files in the target passed as argument.
# Note: The generated C++ source files will be linked as static library
#       and then added to the target as dependency.
function(nuria_tria Target)
  get_target_property(NURIA_SOURCE_FILES ${Target} SOURCES)
  get_target_property(NURIA_INC_DIRS ${Target} INCLUDE_DIRECTORIES)
  
  if(NOT TARGET tria)
    message(WARNING "Tria is not enabled, Target ${Target} won't have runtime information generated.")
    return()
  endif()
  
  SET(NURIA_TRIA_FILES )
  SET(TRIA_EXTRA_INCLUDES )
  
  # Fetch libc/libc++ include directories for win32
  if(WIN32)
    win32_stdlib_include(TRIA_EXTRA_INCLUDES)
  endif()
  
  foreach(file ${NURIA_SOURCE_FILES})
    if("${file}" MATCHES "\\.[hH]..$")
      string(REGEX REPLACE "[^a-zA-Z0-9]" "_" OUTFILE "${file}")
      string(REGEX REPLACE "(^.*)_[^_]*$" "${CMAKE_CURRENT_BINARY_DIR}/tria_\\1.cpp" OUTFILE "${OUTFILE}")
      
      LIST(APPEND NURIA_TRIA_FILES ${OUTFILE})
      
      get_property(NURIA_HAS_RULE SOURCE ${OUTFILE} PROPERTY GENERATED SET)
      
      if(NOT NURIA_HAS_RULE)
        add_custom_command(
            OUTPUT "${OUTFILE}"
            COMMAND tria -cxx-output=${OUTFILE} ${file} -- ${NURIA_INC_DIRS} ${TRIA_EXTRA_INCLUDES}
            IMPLICIT_DEPENDS CXX ${file}
            COMMENT "Running tria on ${file}"
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
      endif()
    endif()
  endforeach()
  
  # Only add the library if there are matches
  if (NURIA_TRIA_FILES)
    add_library("${Target}_tria" STATIC ${NURIA_TRIA_FILES})
    
    # Add targets imports to tria target
    get_target_property(NURIA_LINK_INTERFACES ${Target} INTERFACE_LINK_LIBRARIES)
    target_link_libraries(${Target}_tria ${NURIA_LINK_INTERFACES})
    
    if (NURIA_INC_DIRS)
      set_target_properties("${Target}_tria" PROPERTIES INCLUDE_DIRECTORIES "${NURIA_INC_DIRS}")
    endif()
    
    # TODO: Won't work with MSVC!
    target_link_libraries(${Target} -Wl,--whole-archive "${Target}_tria" -Wl,--no-whole-archive)
  endif()
  
endfunction(nuria_tria)
