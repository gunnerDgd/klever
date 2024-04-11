function   (kernel_image_executable NAME EXECUTABLE)
    get_target_property(PATH_EXECUTABLE ${EXECUTABLE} RUNTIME_OUTPUT_DIRECTORY)
    get_target_property(NAME_EXECUTABLE ${EXECUTABLE} OUTPUT_NAME)

    string (APPEND PATH    ${KLEVER_PATH_IMAGE}/${NAME}/image)
    string (APPEND COMMAND "cp ${PATH_EXECUTABLE}/${NAME_EXECUTABLE} ${PATH}/bin")

    add_custom_target(${NAME}-${EXECUTABLE} COMMAND ${COMMAND})
    add_dependencies (${NAME} ${EXECUTABLE})
endfunction()