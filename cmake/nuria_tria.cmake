# CMake file for the nuria_tria() helper function.
# Copyright by the NuriaProject under the zlib license. (See LICENSE)

include(${CMAKE_CURRENT_LIST_DIR}/win32_stdlib_include.cmake)

# Runs tria on all C++ header-files in the target passed as argument.
# Note: The generated C++ source files will be linked as static library
#       and then added to the target as dependency.
function(nuria_tria Target)
  get_target_property(NURIA_SOURCE_FILES ${Target} SOURCES)
  get_target_property(NURIA_INC_DIRS ${Target} INCLUDE_DIRECTORIES)
  get_target_property(NURIA_TARGET_DEPENDS ${Target} INTERFACE_LINK_LIBRARIES)
  foreach (dependency ${NURIA_TARGET_DEPENDS})
    get_target_property(dependency_inc_dir ${dependency} INTERFACE_INCLUDE_DIRECTORIES)
    LIST(APPEND NURIA_INC_DIRS ${dependency_inc_dir})
  endforeach(dependency)
  LIST(REMOVE_DUPLICATES NURIA_INC_DIRS)
  
  if(NOT TARGET tria)
    message(WARNING "Tria is not enabled, Target ${Target} won't have runtime information generated.")
    return()
  endif()
  
  # Fetch libc/libc++ include directories for win32
  if(WIN32)
    SET(TRIA_EXTRA_INCLUDES )
    win32_stdlib_include(TRIA_EXTRA_INCLUDES)
    LIST(APPEND NURIA_INC_DIRS ${TRIA_EXTRA_INCLUDES})
  endif()
  
  # Prepare include dirs arguments
  SET(NURIA_INCDIR_ARGUMENT )
  foreach(Path ${NURIA_INC_DIRS})
    LIST(APPEND NURIA_INCDIR_ARGUMENT -I${Path})
  endforeach()
  
  # Find header files
  SET(NURIA_TRIA_INFILES )
  foreach(file ${NURIA_SOURCE_FILES})
    if("${file}" MATCHES "\\.[hH]..$")
      LIST(APPEND NURIA_TRIA_INFILES ${file})
    endif()
  endforeach()
  
  # Only add the library if there are matches
  if(NURIA_TRIA_INFILES)
    SET(OUTFILE "${CMAKE_CURRENT_BINARY_DIR}/tria_${Target}.cpp")
    add_custom_command(
        OUTPUT "${OUTFILE}"
        COMMAND tria -cxx-output=${OUTFILE} ${NURIA_TRIA_INFILES} ${NURIA_INCDIR_ARGUMENT}
        DEPENDS ${NURIA_TRIA_INFILES}
        COMMENT "Running tria for Target ${Target}"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    
    # 
    add_library("${Target}_tria" STATIC ${OUTFILE})
    
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
