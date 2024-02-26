function   (add_kernel par_name par_maj par_min)
    if (NOT EXISTS ${PRESET_KERNEL_DIR}/linux-${par_maj}.${par_min}.tar.gz)
        set    (par_url "https://cdn.kernel.org/pub/linux/kernel/")
        string (APPEND     par_url "v${par_maj}.x/linux-${par_maj}.${par_min}.tar.gz")
        file   (DOWNLOAD ${par_url} "${PRESET_KERNEL_DIR}/linux-${par_maj}.${par_min}.tar.gz")
    endif ()

    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_name})
        execute_process(COMMAND tar xvzf  ${PRESET_KERNEL_DIR}/linux-${par_maj}.${par_min}.tar.gz                           WORKING_DIRECTORY ${PRESET_KERNEL_DIR})
        execute_process(COMMAND mv        ${PRESET_KERNEL_DIR}/linux-${par_maj}.${par_min} ${PRESET_KERNEL_DIR}/${par_name} WORKING_DIRECTORY ${PRESET_KERNEL_DIR})
    endif()

    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_name}/.config)
        execute_process(COMMAND konsole --workdir ${PRESET_KERNEL_DIR}/${par_name} --hold -e make menuconfig -j${PRESET_JOB_COUNT})
    endif()

    add_custom_target    (
        ${par_name}-config
        COMMAND konsole --workdir ${PRESET_KERNEL_DIR}/${par_name} --hold -e make menuconfig -j${PRESET_JOB_COUNT}
        WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_name}
    )

    add_custom_target(${par_name}-clean COMMAND make clean WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_name})
    add_custom_target(${par_name}-build
        COMMAND sudo make -j${PRESET_JOB_COUNT} bzImage
        WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_name}
    )
endfunction()