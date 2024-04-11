function   (kernel_clean NAME)
    string (APPEND PATH    "${KLEVER_KERNEL_PATH}/${NAME_KERNEL}")
    string (APPEND COMMAND "make clean")

    if   (NOT EXISTS ${PATH})
        message("[Klever] Kernel named ${NAME_KERNEL} not found at ${KLEVER_KERNEL_PATH}")
        message(SEND_ERROR "Abort")
    endif()

    add_custom_target(${NAME} COMMAND ${COMMAND} WORKING_DIRECTORY ${PATH})
endfunction()