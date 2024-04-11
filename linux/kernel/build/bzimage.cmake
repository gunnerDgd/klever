function   (kernel_build_bzimage NAME)
    string (APPEND PATH    "${KLEVER_PATH_KERNEL}/${NAME}")
    string (APPEND COMMAND "make bzImage -j${KLEVER_JOB}")

    if   (NOT EXISTS ${PATH})
        message("[Klever] Kernel named ${NAME} not found at ${KLEVER_PATH_KERNEL}")
        message(SEND_ERROR "Abort")
    endif()

    add_custom_target(${NAME}-bzimage COMMAND sudo -S /bin/bash -c ${COMMAND} WORKING_DIRECTORY ${PATH})
endfunction()