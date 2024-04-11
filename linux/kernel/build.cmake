include   (${CMAKE_CURRENT_LIST_DIR}/build/bzimage.cmake)
include   (${CMAKE_CURRENT_LIST_DIR}/build/modules.cmake)
include   (${CMAKE_CURRENT_LIST_DIR}/build/vmlinux.cmake)

function  (kernel_build NAME)
    string(APPEND PATH    "${KLEVER_KERNEL_PATH}/${NAME}")
    string(APPEND COMMAND "make -j${KLEVER_JOB}")

    if   (NOT EXISTS ${PATH})
        message("[Klever] Kernel named ${NAME} not found at ${KLEVER_KERNEL_PATH}")
        message(SEND_ERROR "Abort")
    endif()

    add_custom_target(${NAME} COMMAND ${COMMAND} WORKING_DIRECTORY ${PATH})
endfunction()