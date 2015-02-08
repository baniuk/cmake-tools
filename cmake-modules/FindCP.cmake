#.rst:
# FindCP
# --------
#
# Find cp
#
# This module looks for cp - Unix version of copy command. This module defines the following values:
#
# ::
#
#   CP_EXECUTABLE: the full path to the cp tool.
#   CP_FOUND: True if cp has been found.

#=============================================================================
# Based on FindWget

include(${CMAKE_ROOT}/Modules/FindCygwin.cmake)

find_program(CP_EXECUTABLE
  cp
  ${CYGWIN_INSTALL_PATH}/bin
)

# handle the QUIETLY and REQUIRED arguments and set WGET_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(cp DEFAULT_MSG CP_EXECUTABLE)

mark_as_advanced( CP_EXECUTABLE )

# WGET option is deprecated.
# use WGET_EXECUTABLE instead.
set (cp ${CP_EXECUTABLE} )
