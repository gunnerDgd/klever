function   (kernel_build_vmlinux NAME NAME_KERNEL)
    string (APPEND PATH    "${KLEVER_PATH_KERNEL}/${NAME_KERNEL}")
    string (APPEND COMMAND "make vmlinux -j${KLEVER_JOB}")

    if   (NOT EXISTS ${PATH})
        message("[Klever] Kernel named ${NAME_KERNEL} not found at ${KLEVER_PATH_KERNEL}")
        message(SEND_ERROR "Abort")
    endif()

    add_custom_target(${NAME} COMMAND sudo -S /bin/bash -c ${COMMAND} WORKING_DIRECTORY ${PATH})
endfunction()