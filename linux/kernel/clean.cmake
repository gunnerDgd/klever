function  (kernel_clean NAME)
    string(APPEND PATH    "${KLEVER_PATH_KERNEL}/${NAME}")
    if    (NOT EXISTS ${PATH})
        message("[Klever] Kernel named ${NAME} not found at ${KLEVER_PATH_KERNEL}")
        message(SEND_ERROR "Abort")
    endif()

    add_custom_target(${NAME}-clean COMMAND sudo -S make clean WORKING_DIRECTORY ${PATH})
endfunction()