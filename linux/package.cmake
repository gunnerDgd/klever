set (KLEVER_PATH_PACKAGE ${KLEVER_PATH}/package)
file(MAKE_DIRECTORY      ${KLEVER_PATH_PACKAGE})

include (${CMAKE_CURRENT_LIST_DIR}/package/add.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/package/define.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/package/include.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/package/module.cmake)