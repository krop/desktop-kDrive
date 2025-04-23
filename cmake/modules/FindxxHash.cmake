# SPDX-FileCopyrightText: 2025 Christophe Marin <christophe@krop.fr>
#
# SPDX-License-Identifier:  BSD-2-Clause

#[=======================================================================[.rst:
FindxxHash
-------------

Try to find xxhash library.

The following variables will be defined:

``xxHash_FOUND``
    True if xxhash is available
``xxHash_VERSION``
    xxhash version
``xxHash_LIBRARIES``
    xxhash libraries. This variable can be used with target_link_libraries()
``xxHash_INCLUDE_DIRS``
    Include directories of xxhash. This variable can be used with target_include_directories()

If ``xxHash_FOUND`` is TRUE, the following imported target will be defined:

``xxHash::xxhash``
    The xxhash library

Using the imported targets is recommended.

#]=======================================================================]

find_package(PkgConfig QUIET)
pkg_check_modules(PC_xxHash QUIET IMPORTED_TARGET libxxhash)

find_library(xxHash_LIBRARIES
    NAMES xxhash
    HINTS ${PC_xxHash_LIBRARY_DIRS}
)

find_path(xxHash_INCLUDE_DIRS
    NAMES xxhash.h
    HINTS ${PC_xxHash_INCLUDE_DIRS}
)

set(xxHash_VERSION ${PC_xxHash_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(xxHash
    FOUND_VAR
        xxHash_FOUND
    REQUIRED_VARS
        xxHash_LIBRARIES
        xxHash_INCLUDE_DIRS
    VERSION_VAR
        xxHash_VERSION
)

if(xxHash_FOUND AND NOT TARGET xxHash::xxhash)
    add_library(xxHash::xxhash UNKNOWN IMPORTED)
    set_target_properties(xxHash::xxhash PROPERTIES
        IMPORTED_LOCATION "${xxHash_LIBRARIES}"
        INTERFACE_COMPILE_OPTIONS "${PC_xxHash_CFLAGS}"
        INTERFACE_INCLUDE_DIRECTORIES "${xxHash_INCLUDE_DIRS}")
endif()

include(FeatureSummary)
set_package_properties(xxhash PROPERTIES
    DESCRIPTION "Extremely fast hash algorithm"
    URL "https://xxhash.com/"
)

# Compatibility variable
set(XXHASH_SHARED_LIBRARY "${xxHash_LIBRARIES}")

mark_as_advanced(xxHash_LIBRARIES xxHash_INCLUDE_DIRS xxHash_VERSION)
