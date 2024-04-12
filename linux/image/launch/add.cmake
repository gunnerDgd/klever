function   (add_kernel_launch NAME KERNEL IMAGE MEM)
    string (APPEND KERNEL_PATH ${KLEVER_PATH_KERNEL}/${KERNEL}/arch/)
    string (APPEND KERNEL_PATH ${KLEVER_ARCH}/)
    string (APPEND KERNEL_PATH boot/)
    string (APPEND KERNEL_PATH bzImage)

    string (APPEND IMAGE_PATH "${KLEVER_PATH_IMAGE}/${IMAGE}/")
    string (APPEND IMAGE_PATH "${IMAGE}.img")

    string (APPEND PATH "${KLEVER_PATH_IMAGE}/${IMAGE}/")
    string (APPEND PATH "${NAME}.sh")

    file (REMOVE ${PATH})
    file (APPEND ${PATH} "#!/bin/sh\n")
    file (APPEND ${PATH} "nohup qemu-system-x86_64 ")
    file (APPEND ${PATH} "-append \"nokaslr\" -S -s ")
    file (APPEND ${PATH} "-m ${MEM} ")

    file (APPEND ${PATH} "-initrd ${IMAGE_PATH} ")
    file (APPEND ${PATH} "-kernel ${KERNEL_PATH} ")
    file (APPEND ${PATH} "&")

    add_custom_target(${NAME} COMMAND /bin/bash ${PATH} WORKING_DIRECTORY ${KLEVER_PATH_IMAGE}/${IMAGE})
    add_dependencies (${NAME} ${IMAGE})
endfunction()