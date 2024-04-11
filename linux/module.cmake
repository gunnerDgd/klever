set (KLEVER_PATH_MODULE ${KLEVER_PATH}/module)
file(MAKE_DIRECTORY     ${KLEVER_PATH_MODULE})

include (${CMAKE_CURRENT_LIST_DIR}/module/add.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/module/define.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/module/include.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/module/source.cmake)