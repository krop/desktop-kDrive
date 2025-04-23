# SPDX-FileCopyrightText: 2025 Christophe Marin <christophe@krop.fr>
#
# SPDX-License-Identifier:  BSD-2-Clause

#[=======================================================================[.rst:
Findlog4cplus
-------------

Try to find log4cplus library.

The following variables will be defined:

``log4cplus_FOUND``
    True if log4cplus is available
``log4cplus_VERSION``
    log4cplus version
``log4cplus_LIBRARIES``
    log4cplus libraries. This variable can be used with target_link_libraries()
``log4cplusU_LIBRARIES``
    log4cplusU libraries. This variable can be used with target_link_libraries()
``log4cplus_INCLUDE_DIRS``
    Include directories of log4cplus. This variable can be used with target_include_directories()

If ``log4cplus_FOUND`` is TRUE, the following imported targets will be defined:

``log4cplus::log4cplus``
    The log4cplus library
``log4cplus::log4cplusU``
    The log4cplus library

Using the imported targets is recommended.

#]=======================================================================]

find_package(PkgConfig QUIET)
pkg_check_modules(PC_log4cplus QUIET IMPORTED_TARGET log4cplus)

find_library(log4cplus_LIBRARIES
    NAMES log4cplus
    HINTS ${PC_log4cplus_LIBRARY_DIRS}
)

find_library(log4cplusU_LIBRARIES
    NAMES log4cplusU
    HINTS ${PC_log4cplus_LIBRARY_DIRS}
)

find_path(log4cplus_INCLUDE_DIRS
    NAMES log4cplus/logger.h
    HINTS ${PC_log4cplus_INCLUDE_DIRS}
)

set(log4cplus_VERSION ${PC_log4cplus_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(log4cplus
    FOUND_VAR
        log4cplus_FOUND
    REQUIRED_VARS
        log4cplus_LIBRARIES
        log4cplusU_LIBRARIES
        log4cplus_INCLUDE_DIRS
    VERSION_VAR
        log4cplus_VERSION
)

if(log4cplus_FOUND AND NOT TARGET log4cplus::log4cplus)
    add_library(log4cplus::log4cplus UNKNOWN IMPORTED)
    set_target_properties(log4cplus::log4cplus PROPERTIES
        IMPORTED_LOCATION "${log4cplus_LIBRARIES}"
        INTERFACE_COMPILE_OPTIONS "${PC_log4cplus_CFLAGS}"
        INTERFACE_INCLUDE_DIRECTORIES "${log4cplus_INCLUDE_DIRS}")
endif()

if(log4cplus_FOUND AND NOT TARGET log4cplus::log4cplusU)
    add_library(log4cplus::log4cplusU UNKNOWN IMPORTED)
    set_target_properties(log4cplus::log4cplusU PROPERTIES
        IMPORTED_LOCATION "${log4cplusU_LIBRARIES}"
        INTERFACE_COMPILE_OPTIONS "${PC_log4cplus_CFLAGS}"
        INTERFACE_INCLUDE_DIRECTORIES "${log4cplus_INCLUDE_DIRS}")
endif()

include(FeatureSummary)
set_package_properties(log4cplus PROPERTIES
    DESCRIPTION "Thread-safe C++ logging API"
    URL "https://sourceforge.net/projects/log4cplus/"
)

mark_as_advanced(log4cplus_LIBRARIES log4cplusU_LIBRARIES log4cplus_INCLUDE_DIRS log4cplus_VERSION)
