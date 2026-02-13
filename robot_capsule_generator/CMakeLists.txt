# Copyright: (C) 2014 Walkman Consortium
# Authors: Alessio Rocchi
# CopyPolicy: Released under the terms of the GNU GPL v2.0.

cmake_minimum_required(VERSION 3.20)
project(robot_capsule_generator)

# CMake policies
if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 OLD)
    cmake_policy(SET CMP0005 NEW)
    cmake_policy(SET CMP0017 NEW)
endif(COMMAND cmake_policy)

include(ExternalProject)
find_package(PkgConfig)

# Debug flags
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=return-type -Werror=address -Werror=parentheses")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/")

# Find dependencies
find_package(Eigen3 REQUIRED)
find_package(Boost REQUIRED COMPONENTS system filesystem program_options date_time)
find_package(urdf REQUIRED)
find_package(srdfdom REQUIRED)
find_package(moveit_core REQUIRED)

pkg_check_modules(roboptim_capsule roboptim-capsule)
if(NOT roboptim_capsule_FOUND)
    message(FATAL_ERROR "roboptim-capsule not found. Aborting")
endif()

# Include directories
include_directories(
    include
    ${roboptim_capsule_INCLUDE_DIRS}
    ${EIGEN3_INCLUDE_DIR}
    ${Boost_INCLUDE_DIRS}   # Still useful for old headers
)

link_directories(${roboptim_capsule_LIBRARY_DIRS})

# trimesh2 optional
find_package(trimesh2 QUIET)
if(NOT trimesh2_FOUND)
    set(trimesh2_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/trimesh2/")
    set(trimesh2_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/external/src/trimesh2-ext-build/")

    ExternalProject_Add(trimesh2-ext 
        SOURCE_DIR "${trimesh2_SOURCE_DIR}"
        PREFIX "${CMAKE_CURRENT_BINARY_DIR}/external"
        CONFIGURE_COMMAND ""
        BUILD_COMMAND "make"
        INSTALL_COMMAND ""
    )
    link_directories("${trimesh2_BINARY_DIR}/lib/")
    set(trimesh2_INCLUDE_DIRS "${trimesh2_SOURCE_DIR}/include")
    set(trimesh2_LIBRARIES trimesh gomp)
    add_custom_target(copy_trimesh2_to_build ALL 
        ${CMAKE_COMMAND} -E copy_directory ${trimesh2_SOURCE_DIR} ${trimesh2_BINARY_DIR}
    )
    add_dependencies(trimesh2-ext copy_trimesh2_to_build)
endif()

include_directories("${trimesh2_INCLUDE_DIRS}")

# Gather headers
file(GLOB_RECURSE generator_INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}/include" *.h)

# Create executable
add_executable(robot_capsule_generator 
    src/robot_capsule_generator.cpp
    ${generator_INCLUDES}
)

# Ensure trimesh2 build finishes first
if(TARGET trimesh2-ext)
    add_dependencies(robot_capsule_generator trimesh2-ext)
endif()

# Modern Boost linking
target_link_libraries(robot_capsule_generator
    PRIVATE 
        Boost::system
        Boost::filesystem
        Boost::program_options
        Boost::date_time
        ${roboptim_capsule_LIBRARIES}
        ${trimesh2_LIBRARIES}
)

# Install rules
install(TARGETS robot_capsule_generator
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

install(PROGRAMS 
    python/robot_capsule_urdf 
    python/robot_capsule_urdf_to_rviz 
    DESTINATION bin
)

