function   (kernel_image_module NAME MODULE)
    string (APPEND PATH_MODULE ${KLEVER_PATH_MODULE}/${MODULE}/${MODULE}.ko)
    string (APPEND PATH        ${KLEVER_PATH_IMAGE}/${NAME}/image)

    string (APPEND COMMAND     "cp ${PATH_MODULE} ${PATH}/lib/${MODULE}.ko")
    file   (APPEND ${PATH}/image/startup.sh "insmod /lib/${MODULE}.ko\n")

    add_custom_target(${NAME}-${MODULE} COMMAND ${COMMAND})
    add_dependencies (${NAME} ${MODULE})
endfunction()