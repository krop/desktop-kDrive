# SPDX-FileCopyrightText: 2025 Christophe Marin <christophe@krop.fr>
#
# SPDX-License-Identifier:  BSD-2-Clause

#[=======================================================================[.rst:
Findutf8proc
-------------

Try to find utf8proc library.

The following variables will be defined:

``utf8proc_FOUND``
    True if utf8proc is available
``utf8proc_VERSION``
    utf8proc version
``utf8proc_LIBRARIES``
    utf8proc libraries. This variable can be used with target_link_libraries()
``utf8proc_INCLUDE_DIRS``
    Include directories of utf8proc. This variable can be used with target_include_directories()

If ``utf8proc_FOUND`` is TRUE, the following imported target will be defined:

``utf8proc::utf8proc``
    The utf8proc library

Using the imported targets is recommended.

#]=======================================================================]

find_package(PkgConfig QUIET)
pkg_check_modules(PC_utf8proc QUIET IMPORTED_TARGET libutf8proc)

find_library(utf8proc_LIBRARIES
    NAMES utf8proc
    HINTS ${PC_utf8proc_LIBRARY_DIRS}
)

find_path(utf8proc_INCLUDE_DIRS
    NAMES utf8proc.h
    HINTS ${PC_utf8proc_INCLUDE_DIRS}
)

set(utf8proc_VERSION ${PC_utf8proc_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(utf8proc
    FOUND_VAR
        utf8proc_FOUND
    REQUIRED_VARS
        utf8proc_LIBRARIES
        utf8proc_INCLUDE_DIRS
    VERSION_VAR
        utf8proc_VERSION
)

if(utf8proc_FOUND AND NOT TARGET utf8proc::utf8proc)
    add_library(utf8proc::utf8proc UNKNOWN IMPORTED)
    set_target_properties(utf8proc::utf8proc PROPERTIES
        IMPORTED_LOCATION "${utf8proc_LIBRARIES}"
        INTERFACE_COMPILE_OPTIONS "${PC_utf8proc_CFLAGS}"
        INTERFACE_INCLUDE_DIRECTORIES "${utf8proc_INCLUDE_DIRS}")
endif()

include(FeatureSummary)
set_package_properties(utf8proc PROPERTIES
    DESCRIPTION "Library for processing UTF-8 encoded Unicode strings"
    URL "https://julialang.org/utf8proc"
)

mark_as_advanced(utf8proc_LIBRARIES utf8proc_INCLUDE_DIRS utf8proc_VERSION)
