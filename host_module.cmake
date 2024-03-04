if    (UNIX AND NOT APPLE)
    include(${CMAKE_CURRENT_LIST_DIR}/linux/host_module.cmake)
endif ()
