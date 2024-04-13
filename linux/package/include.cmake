function  (kernel_package_include NAME)
    string(APPEND BUILD ${KLEVER_PATH_PACKAGE}/${NAME}/Kbuild)
    if    (NOT EXISTS ${BUILD})
        message("[Klever] Package ${NAME} is malformed")
        message(SEND_ERROR "Abort")
    endif ()

    foreach    (INC IN LISTS ARGN)
        file   (APPEND ${BUILD} "ccflags-y +=")
        file   (APPEND ${BUILD} "-I${INC}\n")
    endforeach ()
    file (APPEND ${BUILD} "\n")
    unset(BUILD)
endfunction()