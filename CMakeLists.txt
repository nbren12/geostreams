# CMakeLists files in this project can
# refer to the root source directory of the project as ${HELLO_SOURCE_DIR} and
# to the root binary directory of the project as ${HELLO_BINARY_DIR}.
cmake_minimum_required (VERSION 2.8.11)
project (geostreams C Fortran)


# Local CMake modules
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)


# hiredis
find_package(hiredis)

include_directories(${hiredis_INCLUDE_DIR})

add_subdirectory (src)
add_subdirectory (test)
