if    (UNIX AND NOT APPLE)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/linux/kernel.cmake)
endif ()