function   (kernel_feature_define NAME KERNEL)
    string (APPEND PATH_KERNEL  ${KLEVER_PATH_KERNEL}/${KERNEL})
    string (APPEND PATH_FEATURE ${PATH_KERNEL}/klever/${NAME})
    string (APPEND BUILD        ${PATH_FEATURE}/Kbuild)

    if   (NOT EXISTS ${PATH_FEATURE})
        message("[Klever] Feature ${NAME} not found")
        message(SEND_ERROR "Abort")
    endif()

    if   (NOT EXISTS ${BUILD})
        message("[Klever] Feature ${NAME} is malformed")
        message(SEND_ERROR "Abort")
    endif()

    foreach    (DEF IN LISTS ARGN)
        file   (APPEND ${BUILD} "ccflags-y +=")
        file   (APPEND ${BUILD} "-D${DEF}\n")
    endforeach ()
    file (APPEND ${BUILD} "\n")
    unset(PATH_KERNEL)
    unset(PATH_FEATURE)
    unset(BUILD)
endfunction()