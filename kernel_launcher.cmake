if    (UNIX AND NOT APPLE)
    include(${CMAKE_CURRENT_LIST_DIR}/linux/kernel_launcher.cmake)
endif ()
