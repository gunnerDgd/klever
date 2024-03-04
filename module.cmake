if    (UNIX AND NOT APPLE)
    include(${CMAKE_CURRENT_LIST_DIR}/linux/module.cmake)
endif ()
