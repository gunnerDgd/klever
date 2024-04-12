include   (${CMAKE_CURRENT_LIST_DIR}/build/bzimage.cmake)
include   (${CMAKE_CURRENT_LIST_DIR}/build/modules.cmake)
include   (${CMAKE_CURRENT_LIST_DIR}/build/vmlinux.cmake)

function  (kernel_build NAME)
    string(APPEND PATH    "${KLEVER_PATH_KERNEL}/${NAME}")
    if    (NOT EXISTS ${PATH})
        message("[Klever] Kernel named ${NAME} not found at ${KLEVER_PATH_KERNEL}")
        message(SEND_ERROR "Abort")
    endif ()

    add_custom_target(${NAME} COMMAND sudo -S make -j${KLEVER_JOB} WORKING_DIRECTORY ${PATH})
endfunction()