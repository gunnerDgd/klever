set (KLEVER_PATH_KERNEL_ARCHIVE ${KLEVER_PATH}/kernel_archive PARENT_SCOPE)
set (KLEVER_PATH_KERNEL         ${KLEVER_PATH}/kernel         PARENT_SCOPE)

file (MAKE_DIRECTORY ${KLEVER_PATH}/kernel_archive)
file (MAKE_DIRECTORY ${KLEVER_PATH}/kernel)

include (${CMAKE_CURRENT_LIST_DIR}/kernel/add.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/kernel/build.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/kernel/clean.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/kernel/config.cmake)
include (${CMAKE_CURRENT_LIST_DIR}/kernel/fetch.cmake)