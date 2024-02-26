function (add_kernel_module par_name par_kernel)
    file (REMOVE ${CMAKE_BINARY_DIR}/${par_name})
    file (APPEND ${CMAKE_BINARY_DIR}/${par_name} "obj-m += ${par_name}.o\n\n")
    add_custom_command (
        OUTPUT            ${par_name}.ko
        COMMAND           cp ${CMAKE_BINARY_DIR}/${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
        COMMAND           make -C /lib/modules/${par_kernel}/build M=${CMAKE_SOURCE_DIR} modules
        COMMAND           rm ${CMAKE_SOURCE_DIR}/Kbuild
        COMMAND           cp ${CMAKE_SOURCE_DIR}/${par_name}.ko ${CMAKE_BINARY_DIR}/${par_name}.ko
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        DEPENDS           ${CMAKE_BINARY_DIR}/${par_name}
        VERBATIM
    )

    add_custom_target (${par_name}-build DEPENDS ${par_name}.ko)
    add_custom_target (
        ${par_name}-clean
        COMMAND cp ${CMAKE_BINARY_DIR}/${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
        COMMAND make -C /lib/modules/${par_kernel}/build M=${CMAKE_SOURCE_DIR} clean
        COMMAND rm ${CMAKE_SOURCE_DIR}/Kbuild
    )

    add_custom_target (
        ${par_name}-install
        COMMAND cp ${CMAKE_BINARY_DIR}/${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
        COMMAND make -C /lib/modules/${par_kernel}/build M=${CMAKE_SOURCE_DIR} modules_install
        COMMAND rm ${CMAKE_SOURCE_DIR}/Kbuild
    )
endfunction()

function   (add_kernel_module_target par_name)
    file       (REMOVE ${CMAKE_BINARY_DIR}/${par_name})
    file       (RELATIVE_PATH par_path ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
    add_library(${par_name} STATIC  ${ARGN})
    foreach    (src IN LISTS ARGN)
        string (FIND ${src} ".h" src_type REVERSE)
        if   (NOT src_type EQUAL -1)
            continue()
        endif()
        string(REPLACE ".c" ".o" src ${src})
        file  (APPEND ${CMAKE_BINARY_DIR}/${par_name} "\t${par_path}/${src}\\")
        file  (APPEND ${CMAKE_BINARY_DIR}/${par_name} "\n")
    endforeach ()
endfunction()

function   (kernel_module_include par_name par_path)
    file(APPEND ${CMAKE_BINARY_DIR}/${par_name} "ccflags-y += -I${par_path}\n\n")
endfunction()

function   (kernel_module_definition par_name par_def)
    file(APPEND ${CMAKE_BINARY_DIR}/${par_name} "ccflags-y += -D${par_def}\n\n")
endfunction()

function     (kernel_module_link_target par_name)
    foreach  (par_target IN LISTS ARGN)
        file (APPEND ${CMAKE_BINARY_DIR}/${par_name}   "${par_name}-objs += \\\n")
        file (READ   ${CMAKE_BINARY_DIR}/${par_target} CONTENTS)
        file (APPEND ${CMAKE_BINARY_DIR}/${par_name}   "${CONTENTS}")
        file (APPEND ${CMAKE_BINARY_DIR}/${par_name} "\n\n")
    endforeach ()
    file  (APPEND ${CMAKE_BINARY_DIR}/${par_name} "\n\n")
endfunction()