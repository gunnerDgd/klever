function (add_host_kernel_module_with_symbol par_name)
    add_custom_command (
            OUTPUT            ${par_name}.ko
            COMMAND           cp ${CMAKE_BINARY_DIR}/host_${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND           make -C /lib/modules/${CMAKE_HOST_SYSTEM_VERSION}/build M=$(PWD) modules
            COMMAND           rm ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND           mv ${CMAKE_SOURCE_DIR}/${par_name}.ko ${CMAKE_BINARY_DIR}/${par_name}-debug.ko
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            DEPENDS           ${CMAKE_BINARY_DIR}/${par_name}
            VERBATIM
    )

    add_custom_target (host_module-${par_name}-debug-build DEPENDS ${par_name}-debug.ko)
    add_custom_target (
            module-${par_name}-debug-clean
            COMMAND cp ${CMAKE_BINARY_DIR}/host_${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND make -C /lib/modules/${CMAKE_HOST_SYSTEM_VERSION}/build M=$(PWD) clean
            COMMAND rm ${CMAKE_SOURCE_DIR}/Kbuild
    )

    file (REMOVE ${CMAKE_BINARY_DIR}/host_${par_name})
    file (APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "ccflags-y += -g -DDEBUG\n")
    file (APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "obj-m += ${par_name}.o\n\n")
endfunction()

function (add_kernel_module par_name par_kernel)
    add_custom_command (
            OUTPUT            ${par_name}.ko
            COMMAND           cp ${CMAKE_BINARY_DIR}/host_${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND           make -C /lib/modules/${CMAKE_HOST_SYSTEM_VERSION}/build M=$(PWD) modules
            COMMAND           rm ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND           mv ${CMAKE_SOURCE_DIR}/${par_name}.ko ${CMAKE_BINARY_DIR}/${par_name}.ko
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            DEPENDS           ${CMAKE_BINARY_DIR}/${par_name}
            VERBATIM
    )

    add_custom_target (module-${par_name}-build DEPENDS ${par_name}.ko)
    add_custom_target (
            module-${par_name}-clean
            COMMAND cp ${CMAKE_BINARY_DIR}/host_${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND make -C /lib/modules/${CMAKE_HOST_SYSTEM_VERSION}/build M=$(PWD) clean
            COMMAND rm ${CMAKE_SOURCE_DIR}/Kbuild
    )

    file (REMOVE ${CMAKE_BINARY_DIR}/host_${par_name})
    file (APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "obj-m += ${par_name}.o\n\n")
endfunction()

function   (host_kernel_module_include par_name par_path)
    if   (NOT EXISTS ${CMAKE_BINARY_DIR}/host_${par_name})
        message("[Klever] No Module ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    file(APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "ccflags-y += -I${par_path}\n\n")
endfunction()

function   (host_kernel_module_definition par_name par_def)
    if   (NOT EXISTS ${CMAKE_BINARY_DIR}/host_${par_name})
        message("[Klever] No Module ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    file(APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "ccflags-y += -D${par_def}\n\n")
endfunction()

function     (host_kernel_module_source par_name)
    if   (NOT EXISTS ${CMAKE_BINARY_DIR}/host_${par_name})
        message("[Klever] No Module ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    foreach  (MOD_SRC IN LISTS ARGN)
        file (APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "${par_name}-objs += \\\n")
        get_target_property(MOD_SRC_LIST ${MOD_SRC} KERNEL_SOURCE)
        get_target_property(MOD_SRC_DIR  ${MOD_SRC} KERNEL_SOURCE_DIR)
        foreach   (SRC ${MOD_SRC_LIST})
            file(RELATIVE_PATH MOD_DIR ${CMAKE_SOURCE_DIR} ${MOD_SRC_DIR})
            file(APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "\t${MOD_DIR}/${SRC}\\\n")
        endforeach()
        file (APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "\n\n")
    endforeach ()
    file  (APPEND ${CMAKE_BINARY_DIR}/host_${par_name} "\n\n")
endfunction()