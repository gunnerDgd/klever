function   (add_kernel_executable NAME KERNEL)
    string (APPEND PATH_KERNEL ${KLEVER_PATH_KERNEL}/)
    string (APPEND PATH_KERNEL ${KERNEL})

    if    (NOT EXISTS ${PATH_KERNEL})
        message("[Klever] Kernel ${KERNEL} Not exists")
        message(SEND_ERROR)
    endif ()

    add_executable            (${NAME} ${ARGN})
    target_compile_options    (${NAME} PRIVATE "-nostdlib")
    target_compile_options    (${NAME} PRIVATE "-nolibc")
    target_compile_options    (${NAME} PRIVATE "-nostdinc")

    target_compile_options    (${NAME} PRIVATE "-fno-asynchronous-unwind-tables")
    target_compile_options    (${NAME} PRIVATE "-ffreestanding")
    target_compile_options    (${NAME} PRIVATE "-fno-ident")
    target_compile_options    (${NAME} PRIVATE "-lnosys")

    target_link_options       (${NAME} PRIVATE "-nostdlib")
    target_link_options       (${NAME} PRIVATE "-nolibc")
    target_link_options       (${NAME} PRIVATE "-nostdinc")

    target_include_directories(${NAME} PRIVATE "${KLEVER_PATH_KERNEL}/tools/include/nolibc")
    target_include_directories(${NAME} PRIVATE "${KLEVER_PATH_KERNEL}/usr/include")
endfunction()