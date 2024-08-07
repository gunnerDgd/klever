function   (kernel_package_module NAME)
    string (APPEND PATH  "${KLEVER_PATH_PACKAGE}/")
    string (APPEND PATH  "${NAME}")
    string (APPEND BUILD "${PATH}/Kbuild")

    foreach    (MODULE IN LISTS ARGN)
        string (APPEND PATH_MODULE  "${KLEVER_PATH_MODULE}/")
        string (APPEND PATH_MODULE  "${MODULE}")

        file (RELATIVE_PATH PATH_PACKAGE ${PATH} ${PATH_MODULE})
        file (APPEND ${BUILD} "obj-m +=  ${PATH_PACKAGE}/\n")
        unset(PATH_PACKAGE)
        unset(PATH_MODULE)
    endforeach ()
    file (APPEND ${BUILD} "\n\n")
endfunction()