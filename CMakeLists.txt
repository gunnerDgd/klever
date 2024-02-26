cmake_minimum_required(VERSION 3.20)

include(ProcessorCount)
include(${CMAKE_SOURCE_DIR}/cmake/setup.cmake)

include(${CMAKE_SOURCE_DIR}/cmake/module.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/kernel.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/kernel_target.cmake)

add_kernel       (test 6 7.1)
add_kernel_target(test_target test)