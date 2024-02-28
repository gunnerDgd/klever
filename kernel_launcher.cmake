if    (UNIX AND NOT APPLE)
    include(${CMAKE_CURRENT_SOURCE_DIR}/linux/kernel_launcher.cmake)
endif ()