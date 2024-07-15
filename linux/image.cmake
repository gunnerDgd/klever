set (KLEVER_PATH_IMAGE ${KLEVER_PATH}/image)
file(MAKE_DIRECTORY ${KLEVER_PATH}/image)

include(${CMAKE_CURRENT_LIST_DIR}/image/add.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/image/executable.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/image/launch.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/image/module.cmake)