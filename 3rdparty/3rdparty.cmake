# 3rdparty module CMake integration

###### LuaJit (Source: http://luajit.org/git/luajit-2.0.git )
SET(LUAJIT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/luajit)

# Build LuaJit
add_custom_target(build_luajit ALL
                  COMMAND ${CMAKE_MAKE_PROGRAM} TARGET_CFLAGS=-fPIC BUILDMODE=static
                  WORKING_DIRECTORY ${LUAJIT_PATH}/src
                  COMMENT "LuaJit library")

# 
SET(LUAJIT_INCLUDE_DIR ${LUAJIT_PATH}/src)
SET(LUAJIT_LIB ${LUAJIT_INCLUDE_DIR}/libluajit.a)

ADD_LIBRARY(LuaJit IMPORTED STATIC)
add_dependencies(LuaJit build_luajit)
set_property(TARGET LuaJit APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(LuaJit PROPERTIES IMPORTED_LOCATION_NOCONFIG ${LUAJIT_LIB})
