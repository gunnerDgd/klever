# add_kernel_target (Name / Kernel)
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

function (add_kernel_target par_name par_kernel)
    if   (NOT EXISTS ${PRESET_KERNEL_TARGET_DIR}/${par_name})
        message("[Klever] Creating CPIO Source Directory for initramfs Generation...")
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name})
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/dev)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/etc)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/home)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/mnt)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/proc)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/sys)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/usr)
        file   (MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR}/${par_name}/tmp)
        file   (DOWNLOAD ${PRESET_BUSYBOX_URL} ${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin/busybox)
    endif()

    message("[Klever] Removing Previous Script and CPIO Image...\n")
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh)
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/nohup.out)
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}/initramfs.cpio)
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init)
    file   (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name}.img)

    message("[Klever] Generating init script...\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "#!/bin/busybox sh\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox mount -t proc      proc     /proc\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox mount -t sysfs     sysfs    /sys\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox mount -t devtmpfs  devtmpfs /dev\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "/bin/busybox mount -t tmpfs     tmpfs    /tmp\n")
    file   (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}/init "exec /bin/busybox sh\n")

    message("[Klever] Generating Kernel Target Execution Script...\n")
    file (REMOVE ${PRESET_KERNEL_TARGET_DIR}/${par_name})
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "#!/bin/sh\n")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "cd ${par_name}\n")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "chmod +x init\n")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "find . -print0 | cpio --null -ov --format=newc > ../initramfs.cpio\n")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "cd ..\n")

    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "gzip ./initramfs.cpio\n")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "mv ./initramfs.cpio.gz ./${par_name}.img\n")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "nohup qemu-system-x86_64 -append \'nokaslr\' -S -s ")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "-m 256 ")

    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "-initrd ")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "${par_name}.img ")

    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "-kernel ")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "${PRESET_KERNEL_DIR}/${par_kernel}/arch/x86_64/boot/bzImage ")
    file (APPEND ${PRESET_KERNEL_TARGET_DIR}/${par_name}.sh "&")

    add_custom_target (${par_name}-target COMMAND ./${par_name}.sh WORKING_DIRECTORY ${PRESET_KERNEL_TARGET_DIR})
endfunction()

function   (kernel_target_module par_name par_module)
    file(COPY ${CMAKE_BINARY_DIR}/${par_module}.ko ${PRESET_KERNEL_TARGET_DIR}/${par_name}/lib/modules/${par_module}.ko)
endfunction()

function   (kernel_target_binary par_name par_binary)
    file(COPY ${CMAKE_BINARY_DIR}/${par_binary}/${par_binary} ${PRESET_KERNEL_TARGET_DIR}/${par_name}/bin/${par_binary})
endfunction()