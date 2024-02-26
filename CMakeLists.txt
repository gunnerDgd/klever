cmake_minimum_required(VERSION 3.20)

include(ProcessorCount)
include(${CMAKE_SOURCE_DIR}/cmake/setup.cmake)

include(${CMAKE_SOURCE_DIR}/cmake/module.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/kernel.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/kernel_target.cmake)

if   (PRESET_BUILD_EXAMPLE)
    include(${CMAKE_SOURCE_DIR}/examples/add_kernel.cmake)
    include(${CMAKE_SOURCE_DIR}/examples/add_kernel_target.cmake)
endif()