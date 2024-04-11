set (KLEVER_PATH_TOOLS ${KLEVER_PATH}/tools)
file(MAKE_DIRECTORY ${KLEVER_PATH_TOOLS})

if (KLEVER_TOOLS_BUSYBOX)
    include (${CMAKE_CURRENT_LIST_DIR}/tools/busybox.cmake)
endif()