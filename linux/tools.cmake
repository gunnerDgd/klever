set (KLEVER_PATH_TOOLS ${KLEVER_PATH}/tools PARENT_SCOPE)
file(MAKE_DIRECTORY    ${KLEVER_PATH}/tools)

include (${CMAKE_CURRENT_LIST_DIR}/tools/busybox.cmake)