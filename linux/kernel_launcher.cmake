# add_kernel_launcher (Name / Kernel)
#
# <Description>
# Adds Kernel Execution Target to your Project.
# In Linux, This will create ramdisk image contains root file system (rootfs / initrd),
# and automated script to run QEMU in kernel boot mode.
#
# Successful process of this function will add CMake target named ${Name}-target to your CLion / CMake Project.
#
# -> ${Name}-target : Execute automated script generated in CMake project load.
# This will execute QEMU virtual machine with generated rootfs image (initrd) and kernel image (bzImage).
#
# <Arguments>
# [Name]
# Name of the Target. This will be used when you attach module / executable to your virtual environment.
#
# [Kernel]
# Name of the kernel you want to execute, which is added with "add_kernel(...)".
#

function (add_kernel_launcher par_name par_kernel)
    get_target_property(par_kernel_ver kernel-${par_kernel}-build KERNEL_VERSION)
    get_target_property(par_kernel_maj kernel-${par_kernel}-build KERNEL_VERSION_MAJOR)
    get_target_property(par_kernel_min kernel-${par_kernel}-build KERNEL_VERSION_MINOR)
    add_custom_target  (kernel-${par_name}-launch COMMAND sudo -S /bin/sh ./${par_name}.sh WORKING_DIRECTORY ${PRESET_KERNEL_TARGET_DIR})

    if   (NOT EXISTS ${PRESET_KERNEL_TARGET_DIR}/${par_name})
        message("[Klever] Creating rootfs Source Directory for initramfs Generation...")
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name})
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/dev)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/etc)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/home)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/proc)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/sys)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/usr)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/tmp)

        # Create /lib Directory for modprobe / insmod.
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/lib)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/lib/modules)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/lib/modules/${par_kernel_ver})

        message("[Klever] Downloading Busybox from ${PRESET_BUSYBOX_URL}...")
        file   (DOWNLOAD ${PRESET_BUSYBOX_URL} ${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin/busybox)
    endif()

    if   (NOT EXISTS ${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin/busybox)
        message("[Klever] Downloading Busybox from ${PRESET_BUSYBOX_URL}...")
        file   (DOWNLOAD ${PRESET_BUSYBOX_URL} ${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin/busybox)
    endif()

    message("[Klever] Removing Previous Script and CPIO Image...\n")
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}-build.sh)
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh)
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/nohup.out)
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}/initramfs.cpio)

    # Remove Previous Init Scripts
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}/${par_name}.sh)
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init)

    # Remove Previous RootFS Image
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}.img)

    # Remove and Re - Write Init script (${par_name}/init) for RootFS Init Process.
    message("[Klever] Generating init script...\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "#!/bin/busybox sh\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox mount -t proc      proc     /proc\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox mount -t sysfs     sysfs    /sys\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox mount -t devtmpfs  devtmpfs /dev\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox mount -t tmpfs     tmpfs    /tmp\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox sh /${par_name}.sh\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "exec /bin/busybox sh")

    # Remove and Re - Write initrd Generation and QEMU Execution Script
    message("[Klever] Generating Kernel Target Execution Script...\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}-build.sh "#!/bin/sh\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "#!/bin/sh\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "sh ${par_name}-build.sh\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "cd ${par_name}\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "chmod +x ./init\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "chmod +x ./bin/*\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "chown root -R ./*\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "chgrp root -R ./*\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "find . -print0 | cpio --null -ov --format=newc > ../initramfs.cpio\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh       "cd ..\n")

    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "gzip ./initramfs.cpio\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "mv ./initramfs.cpio.gz ./${par_name}.img\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "nohup qemu-system-x86_64 -append \"nokaslr\" -S -s ")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "-m 256 ")

    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "-initrd ")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "${par_name}.img ")

    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "-kernel ")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "${PRESET_KERNEL_DIR}/${par_kernel}/arch/x86_64/boot/bzImage ")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "&")

    set_target_properties(kernel-${par_name}-launch PROPERTIES KERNEL_VERSION_MAJOR ${par_kernel_maj})
    set_target_properties(kernel-${par_name}-launch PROPERTIES KERNEL_VERSION_MINOR ${par_kernel_min})
    set_target_properties(kernel-${par_name}-launch PROPERTIES KERNEL_VERSION       ${par_kernel_ver})
endfunction()

function   (kernel_launcher_module par_name par_module)
    if   (NOT EXISTS ${CMAKE_BINARY_DIR}/${par_name})
        message("[Klever] Module ${par_name} Not Defined")
        message("[Klever] Abort CMake Generation Process.")
        message(SEND_ERROR "Abort")
    endif()
    add_dependencies   (kernel-${par_name}-launch ${par_module}-build)
    get_target_property(par_kernel_ver ${par_name}-launch KERNEL_VERSION)
    set                (par_module_dir ${PRESET_KERNEL_TARGET_DIR}/${par_name}/lib/modules/${par_kernel_ver})

    file(APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}-build.sh       "cp ${CMAKE_BINARY_DIR}/${par_module}.ko ${par_module_dir}\n")
    file(APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init-script.sh "/bin/busybox insmod /lib/modules/${par_kernel_maj}.${par_kernel_min}/${par_module}.ko\n")
    file(APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init-script.sh "/bin/busybox echo \"Module ${par_module}'s Address\"\n")
    file(APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init-script.sh "/bin/busybox cat /sys/module/${par_module}/sections/.text\n\n")
endfunction()

function   (kernel_launcher_module_debug par_name par_module)
    if   (NOT EXISTS ${CMAKE_BINARY_DIR}/${par_name})
        message("[Klever] Module ${par_name} Not Defined")
        message("[Klever] Abort CMake Generation Process.")
        message(SEND_ERROR "Abort")
    endif()
    add_dependencies   (kernel-${par_name}-launch ${par_module}-debug-build)
    get_target_property(par_kernel_ver ${par_name}-launch KERNEL_VERSION)
    set                (par_module_dir ${PRESET_KERNEL_TARGET_DIR}/${par_name}/lib/modules/${par_kernel_ver})

    file(APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}-build.sh       "cp ${CMAKE_BINARY_DIR}/${par_module}.ko ${par_module_dir}\n")
    file(APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init-script.sh "/bin/busybox insmod /lib/modules/${par_kernel_maj}.${par_kernel_min}/${par_module}.ko\n")
    file(APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init-script.sh "/bin/busybox echo \"Module ${par_module}'s Address\"\n")
    file(APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init-script.sh "/bin/busybox cat /sys/module/${par_module}/sections/.text\n\n")
endfunction()

function   (kernel_launcher_binary par_name par_binary)
    add_dependencies     (kernel-${par_name}-launch executable-${par_binary})
    set_target_properties(executable-${par_binary} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin")
    set_target_properties(executable-${par_binary} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin")
    set_target_properties(executable-${par_binary} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin")
endfunction()