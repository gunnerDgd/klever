function   (add_kernel_executable par_name par_kernel)
    add_executable        (executable-${par_name} ${ARGN})
    target_compile_options(executable-${par_name} PRIVATE "-nostdlib")
    target_compile_options(executable-${par_name} PRIVATE "-nolibc")
    target_compile_options(executable-${par_name} PRIVATE "-nostdinc")

    target_compile_options(executable-${par_name} PRIVATE "-fno-asynchronous-unwind-tables")
    target_compile_options(executable-${par_name} PRIVATE "-ffreestanding")
    target_compile_options(executable-${par_name} PRIVATE "-fno-ident")
    target_compile_options(executable-${par_name} PRIVATE "-lnosys")

    target_link_options   (executable-${par_name} PRIVATE "-nostdlib")
    target_link_options   (executable-${par_name} PRIVATE "-nolibc")
    target_link_options   (executable-${par_name} PRIVATE "-nostdinc")

    target_include_directories(executable-${par_name} PRIVATE "${PRESET_KERNEL_DIR}/${par_kernel}/tools/include/nolibc")
    target_include_directories(executable-${par_name} PRIVATE "${PRESET_KERNEL_DIR}/${par_kernel}/usr/include")
endfunction()