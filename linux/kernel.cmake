# Definition
# ==========
# add_kernel (Name / Major Version / Minor Version)
#
# <Description>
# Downloads and Adds Linux Kernel and its CMake Target.
# Successful process of this function will add three CMake target to your CLion / CMake Project.
#
# -> ${Name}-config : Call "make menuconfig" for your kernel. Execute this target if you want to change your kernel's build config.
# -> ${Name}-clean : Call "make clean" for your kernel. Execute this target if you want to clean all build result and initialize your build environment.
# -> ${Name}-build : Builds "bzImage" (= make bzImage) for QEMU boot. This will build Kenrel Image and Symbol File (vmlinux) for QEMU debugging.
#
# <Arguments>
# [Name]
# Alias of the Kernel. This will be used when you execute the kernel in virtual environment (e.g. QEMU).
#
# [Major Version]
# Major Version of the kernel. If the kernel version you wants to add is "6.7.1",
# the major version is "6".
#
# [Minor Version]
# Minor Version of the kernel. If the kernel version you wants to add is "6.7.1",
# the major version is "7.1".
#

function   (add_kernel par_name par_maj par_min)
    string(APPEND par_config "${PRESET_TERMINAL} ")
    string(APPEND par_config "${PRESET_TERMINAL_DIR}${PRESET_KERNEL_DIR}/${par_name} ")
    string(APPEND par_config "${PRESET_TERMINAL_EXEC} make menuconfig -j${PRESET_JOB_COUNT}")
    if (NOT EXISTS ${PRESET_KERNEL_DIR}/linux-${par_maj}.${par_min}.tar.gz)
        set    (par_url "https://cdn.kernel.org/pub/linux/kernel/")
        string (APPEND     par_url "v${par_maj}.x/linux-${par_maj}.${par_min}.tar.gz")

        message("[Klever] Kernel Not Exists. Try to Download Kernel at Linux Kernel Archive...")
        message("[Klever] Target URL : ${par_url}")
        file   (DOWNLOAD ${par_url} "${PRESET_KERNEL_DIR}/linux-${par_maj}.${par_min}.tar.gz")
    endif ()

    # Decompress and Build Entire Kernel (vmlinux / bzImage).
    # This will Generate Kernel Modules' Object File which is needed to build custom module.
    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_name})
        message        ("[Klever] Decompressing Kernel Archive...")
        execute_process(COMMAND tar xvzf  ${PRESET_KERNEL_DIR}/linux-${par_maj}.${par_min}.tar.gz                           WORKING_DIRECTORY ${PRESET_KERNEL_DIR})
        execute_process(COMMAND mv        ${PRESET_KERNEL_DIR}/linux-${par_maj}.${par_min} ${PRESET_KERNEL_DIR}/${par_name} WORKING_DIRECTORY ${PRESET_KERNEL_DIR})
        execute_process(COMMAND /bin/bash -c ${par_config})
    endif()

    # If there are no .config in kernel directory,
    # Klever will suppose that no configuration progress made before, , and run "make menuconfig" for build configuration.
    if    (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_name}/.config)
        execute_process(COMMAND /bin/bash -c ${par_config})
    endif ()

    message("[Klever] Successfully Added, Configured, and Built Kernel.")
    message("[Klever] Your Kernel is Saved At ${PRESET_KERNEL_DIR}/${par_name}.")

    add_custom_target(${par_name}-config      COMMAND  /bin/bash -c ${par_config})
    add_custom_target(${par_name}-clean       COMMAND make clean                                 WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_name})
    add_custom_target(${par_name}-build-image COMMAND sudo -S make -j${PRESET_JOB_COUNT} bzImage WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_name})
    add_custom_target(${par_name}-build       COMMAND sudo -S make -j${PRESET_JOB_COUNT} vmlinux WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_name})

    set_target_properties(${par_name}-config      PROPERTIES KERNEL_VERSION       "${par_maj}.${par_min}")
    set_target_properties(${par_name}-config      PROPERTIES KERNEL_VERSION_MAJOR ${par_maj})
    set_target_properties(${par_name}-config      PROPERTIES KERNEL_VERSION_MINOR ${par_min})

    set_target_properties(${par_name}-clean       PROPERTIES KERNEL_VERSION       "${par_maj}.${par_min}")
    set_target_properties(${par_name}-clean       PROPERTIES KERNEL_VERSION_MAJOR ${par_maj})
    set_target_properties(${par_name}-clean       PROPERTIES KERNEL_VERSION_MINOR ${par_min})

    set_target_properties(${par_name}-build       PROPERTIES KERNEL_VERSION       "${par_maj}.${par_min}")
    set_target_properties(${par_name}-build       PROPERTIES KERNEL_VERSION_MAJOR ${par_maj})
    set_target_properties(${par_name}-build       PROPERTIES KERNEL_VERSION_MINOR ${par_min})

    set_target_properties(${par_name}-build-image PROPERTIES KERNEL_VERSION       "${par_maj}.${par_min}")
    set_target_properties(${par_name}-build-image PROPERTIES KERNEL_VERSION_MAJOR ${par_maj})
    set_target_properties(${par_name}-build-image PROPERTIES KERNEL_VERSION_MINOR ${par_min})
endfunction()
