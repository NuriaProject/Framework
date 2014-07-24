# Common variables for the NuriaFramework

# Version numbers
SET(NURIA_VERSION 0.1.0)
SET(NURIA_SOVERSION 0)

# Tria binary path
SET(NURIA_TRIA_BIN ${CMAKE_INSTALL_PREFIX}/bin/tria)

IF(WIN32)
  SET(NURIA_TRIA_BIN ${NURIA_TRIA_BIN}.exe)
ENDIF()
