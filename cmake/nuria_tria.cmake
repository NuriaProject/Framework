# CMake file for the nuria_tria() helper function.
# Copyright by the NuriaProject under the zlib license. (See LICENSE)

# Runs tria on all C++ header-files in the target passed as argument.
# Note: The generated C++ source files will be linked as static library
#       and then added to the target as dependency.
function(nuria_tria Target)
  get_target_property(NURIA_SOURCE_FILES ${Target} SOURCES)
  get_target_property(NURIA_INC_DIRS ${Target} INCLUDE_DIRECTORIES)
  
  if(NOT HasTria)
    message(WARNING "Tria is not enabled, Target ${Target} won't have runtime information generated.")
    return()
  endif()
  
  SET(NURIA_TRIA_FILES )
  
  foreach(file ${NURIA_SOURCE_FILES})
    if("${file}" MATCHES "\\.[hH]..$")
      string(REGEX REPLACE "[^a-zA-Z0-9]" "_" OUTFILE "${file}")
      string(REGEX REPLACE "(^.*)_[^_]*$" "${CMAKE_CURRENT_BINARY_DIR}/tria_\\1.cpp" OUTFILE "${OUTFILE}")
      
      LIST(APPEND NURIA_TRIA_FILES ${OUTFILE})
      
      get_property(NURIA_HAS_RULE SOURCE ${OUTFILE} PROPERTY GENERATED SET)
      
      if(NOT NURIA_HAS_RULE)
        add_custom_command(
            OUTPUT "${OUTFILE}"
            COMMAND tria -cxx-output=${OUTFILE} ${file} -- ${NURIA_INC_DIRS}
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
    QT5_USE_MODULES("${Target}_tria" Core)
    
    if (NURIA_INC_DIRS)
      target_include_directories("${Target}_tria" PUBLIC ${NURIA_INC_DIRS})
    endif()
    
    target_link_libraries(${Target} "${Target}_tria")
  endif()
  
endfunction(nuria_tria)
