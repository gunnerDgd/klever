# add_kernel_target() will add Kernel Execution Environment (e.g. QEMU) to your project.
#
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

add_kernel_target(test_target test)