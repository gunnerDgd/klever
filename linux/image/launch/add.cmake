function   (add_kernel_launch NAME KERNEL IMAGE MEM)
    string (APPEND KERNEL_PATH ${KLEVER_PATH_KERNEL}/${KERNEL}/)
    string (APPEND KERNEL_PATH x86/)
    string (APPEND KERNEL_PATH boot/)
    string (APPEND KERNEL_PATH bzImage)

    string (APPEND IMAGE_PATH "${KLEVER_PATH_IMAGE}/${IMAGE}/")
    string (APPEND IMAGE_PATH "${IMAGE}.img")

    string (APPEND PATH "${KLEVER_PATH_IMAGE}/${IMAGE}/")
    string (APPEND PATH "${NAME}.sh")

    if   (NOT EXISTS ${KERNEL_PATH})
        message("[Klever] Kernel ${KERNEL} not defined.")
        message(SEND_ERROR)
    endif()
    if   (NOT EXISTS ${IMAGE})
        message("[Klever] Image ${IMAGE} not defined.")
        message(SEND_ERROR)
    endif()

    file (APPEND ${PATH} "nohup qemu-system-x86_64 ")
    file (APPEND ${PATH} "-append \"nokaslr\" -S -s ")
    file (APPEND ${PATH} "-m ${MEM} ")

    file (APPEND ${PATH} "-initrd ${IMAGE} ")
    file (APPEND ${PATH} "-kernel ${KERNEL} ")
    file (APPEND ${PATH} "&")

    add_custom_target(${NAME} COMMAND /bin/bash ${PATH} WORKING_DIRECTORY ${KLEVER_PATH_IMAGE}/${IMAGE})
    add_dependencies (${NAME} ${IMAGE})
endfunction()