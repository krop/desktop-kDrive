
#
#  SQLITE3_FOUND - system has SQLite3
#  SQLITE3_INCLUDE_DIRS - the SQLite3 include directory
#  SQLITE3_LIBRARIES - Link these to use SQLite3
#  SQLITE3_DEFINITIONS - Compiler switches required for using SQLite3

# SPDX-FileCopyrightText:  2009-2013 Andreas Schneider <asn@cryptomilk.org>
# SPDX-FileCopyrightText: 2025 Christophe Marin <christophe@krop.fr>
#
# SPDX-License-Identifier:  BSD-2-Clause

#[=======================================================================[.rst:
FindSQLite3
-------------

Try to find SQLite3 library.

The following variables will be defined:

``SQLite3_FOUND``
    True if SQLite3 is available
``SQLite3_VERSION``
    SQLite3 version
``SQLite3_LIBRARIES``
    SQLite3 libraries. This variable can be used with target_link_libraries()
``SQLite3_INCLUDE_DIRS``
    Include directories of SQLite3. This variable can be used with target_include_directories()
``SQLite3_DEFINITIONS``
    Compiler switches required for using SQLite3

If ``SQLite3_FOUND`` is TRUE, the following imported target will be defined:

``SQLite3::SQLite3``
    The SQLite3 library

Using the imported targets is recommended.

# Additionally, backward-compatible variables are created:
``SQLITE3_INCLUDE_DIRS``
    Include directories of SQLite3.
``SQLITE3_LIBRARIES``
    SQLite3 libraries.

#]=======================================================================]


find_package(PkgConfig)
pkg_check_modules(PC_SQLite3 QUIET IMPORTED_TARGETS sqlite3)

find_library(SQLite3_LIBRARIES
    NAMES
        sqlite3 sqlite3-0
    HINTS
        ${PC_SQLite3_LIBRARY_DIRS}
)

find_path(SQLite3_INCLUDE_DIRS
    NAMES
        sqlite3.h
    HINTS
        ${PC_SQLite3_INCLUDE_DIRS}
)

if(SQLite3_FIND_VERSION AND PC_SQLite3_VERSION)
    set(SQLite3_VERSION PC_SQLite3_VERSION)
endif()

if (APPLE OR WIN32)
    set(USE_OUR_OWNPC_SQLite3 TRUE)
    set(SQLite3_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/src/3rdparty/sqlite3)
    set(SQLite3_LIBRARIES "")
    set(SQLITE3_SOURCE ${SQLITE3_INCLUDE_DIR}/sqlite3.c)
    message(STATUS "Using own sqlite3 from " ${SQLite3_INCLUDE_DIRS})
else()
    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(SQLite3
        FOUND_VAR
            SQLite3_FOUND
        REQUIRED_VARS
            SQLite3_LIBRARIES
            SQLite3_INCLUDE_DIRS
        VERSION_VAR
            SQLite3_VERSION
    )
endif()

if(SQLite3_FOUND AND NOT TARGET SQLite3::SQLite3)
    add_library(SQLite3::SQLite3 UNKNOWN IMPORTED)
    set_target_properties(SQLite3::SQLite3 PROPERTIES
        IMPORTED_LOCATION "${SQLite3_LIBRARIES}"
        INTERFACE_COMPILE_OPTIONS "${PC_SQLite3_CFLAGS}"
        INTERFACE_INCLUDE_DIRECTORIES "${SQLite3_INCLUDE_DIRS}"
    )
endif()

# Backward compatible variables
set(SQLITE3_INCLUDE_DIRS "${SQLite3_INCLUDE_DIRS}")
set(SQLITE3_LIBRARIES "${SQLite3_LIBRARIES}")
set(SQLITE3_FOUND SQLite3_FOUND)

# show the SQLITE3_INCLUDE_DIRS and SQLITE3_LIBRARIES variables only in the advanced view
mark_as_advanced(SQLite3_LIBRARIES SQLite3_INCLUDE_DIRS SQLite3_VERSION SQLITE3_INCLUDE_DIRS SQLITE3_LIBRARIES)

