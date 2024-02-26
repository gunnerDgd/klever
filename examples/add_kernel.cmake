# add_kernel() adds target kernel at your CMake source directory.
#
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
# =========
# [Name]
# Alias of the Kernel. This will be used when you execute the kernel in virtual environment (e.g. QEMU),
# and attaches module / application to the kernel.
#
# [Major Version]
# Major Version of the kernel. If the kernel version you wants to add is "6.7.1",
# the major version is "6".
#
# [Minor Version]
# Minor Version of the kernel. If the kernel version you wants to add is "6.7.1",
# the major version is "7.1".
#

add_kernel(test 6 7.1)