# - Find the libcouchbase library
# This module defines
#  COUCHBASE_INCLUDE_DIR, path to libcouchbase/couchbase.h, etc.
#  COUCHBASE_LIBRARIES, the libraries required to use libcouchbase.
#  COUCHBASE_FOUND, If false, do not try to use libcouchbase.
# also defined, but not for general use are
# COUCHBASE_LIBRARY, where to find the READLINE library.

IF(APPLE)
  FIND_PATH(COUCHBASE_INCLUDE_DIR NAMES libcouchbase/couchbase.h PATHS
    /opt/local/include
    /opt/include
    /usr/local/include
    /usr/include/
    NO_DEFAULT_PATH
    )
ENDIF(APPLE)
FIND_PATH(COUCHBASE_INCLUDE_DIR NAMES libcouchbase/couchbase.h)

IF(APPLE)
  FIND_LIBRARY(COUCHBASE_LIBRARY NAMES couchbase PATHS
    /opt/local/lib
    /opt/lib
    /usr/local/lib
    /usr/lib
    NO_DEFAULT_PATH
    )
ENDIF(APPLE)
FIND_LIBRARY(COUCHBASE_LIBRARY NAMES couchbase)

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set COUCHBASE_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(Couchbase  DEFAULT_MSG
                                  COUCHBASE_LIBRARY COUCHBASE_INCLUDE_DIR)

MARK_AS_ADVANCED(
  COUCHBASE_INCLUDE_DIR
  COUCHBASE_LIBRARY
)
