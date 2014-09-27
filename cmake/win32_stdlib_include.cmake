# CMake file for the win32_stdlib_include() helper function.
# Copyright by the NuriaProject under the zlib license. (See LICENSE)

# Returns the list of libc/libc++ include directories in a win32 environment.
function(win32_stdlib_include OUTVAR)
  if(NOT MINGW)
    message(WARNING "Cannot create libc include path for MSVC")
    return()
  endif()

  # Fetch GCC Version information
  EXECUTE_PROCESS( COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION )
  STRING( STRIP ${GCC_VERSION} GCC_VERSION )
  EXECUTE_PROCESS( COMMAND ${CMAKE_CXX_COMPILER} -dumpmachine OUTPUT_VARIABLE GCC_MACHINE )
  STRING( STRIP ${GCC_MACHINE} GCC_MACHINE )

  # Fetch GCC/G++ base path
  STRING(REPLACE "/bin" "" GCC_PATH ${CMAKE_CXX_COMPILER})
  STRING(REPLACE "/g++.exe" "" GCC_PATH ${GCC_PATH})
  STRING(REPLACE "/gcc.exe" "" GCC_PATH ${GCC_PATH})

  # Generate list of libc/libc++ include dirs for windows. 
  # Note that not all of these will exist, this is due to reorganization between 4.8.0 and 4.8.2
  SET( ${OUTVAR}
    "${GCC_PATH}/lib/gcc/${GCC_MACHINE}/${GCC_VERSION}/include"
    "${GCC_PATH}/lib/gcc/${GCC_MACHINE}/${GCC_VERSION}/include-fixed"
    "${GCC_PATH}/lib/gcc/${GCC_MACHINE}/${GCC_VERSION}/include/c++"
    "${GCC_PATH}/lib/gcc/${GCC_MACHINE}/${GCC_VERSION}/include/c++/${GCC_MACHINE}"
    "${GCC_PATH}/${GCC_MACHINE}/include"
    "${GCC_PATH}/${GCC_MACHINE}/include/c++"
    "${GCC_PATH}/${GCC_MACHINE}/include/c++/${GCC_MACHINE}"
    "${GCC_PATH}/include"
  PARENT_SCOPE )
endfunction(win32_stdlib_include)
