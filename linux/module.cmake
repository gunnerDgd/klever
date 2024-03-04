function (add_kernel_module_with_symbol par_name par_kernel)
    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_kernel})
        message("[Klever] Kernel \"${par_kernel}\" not exist at directory ${PRESET_KERNEL_DIR}.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    get_target_property(par_kernel_ver kernel-${par_kernel}-build KERNEL_VERSION)
    get_target_property(par_kernel_maj kernel-${par_kernel}-build KERNEL_VERSION_MAJOR)
    get_target_property(par_kernel_min kernel-${par_kernel}-build KERNEL_VERSION_MINOR)
    add_custom_command (
            OUTPUT            ${par_name}-debug.ko
            COMMAND           cp ${CMAKE_BINARY_DIR}/${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND           make -C ${CMAKE_SOURCE_DIR}/kernel/${par_kernel} M=${CMAKE_SOURCE_DIR} modules
            COMMAND           rm ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND           mv ${CMAKE_SOURCE_DIR}/${par_name}.ko ${CMAKE_BINARY_DIR}/${par_name}-debug.ko
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            DEPENDS           ${CMAKE_BINARY_DIR}/${par_name}
            VERBATIM
    )

    add_custom_target (module-${par_name}-debug-build DEPENDS ${par_name}-debug.ko)
    add_custom_target (
            module-${par_name}-debug-clean
            COMMAND cp ${CMAKE_BINARY_DIR}/${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND make -C ${CMAKE_SOURCE_DIR}/kernel/${par_kernel} M=${CMAKE_SOURCE_DIR} clean
            COMMAND rm ${CMAKE_SOURCE_DIR}/Kbuild
    )

    file (REMOVE ${CMAKE_BINARY_DIR}/${par_name})
    file (APPEND ${CMAKE_BINARY_DIR}/${par_name} "ccflags-y += -g -DDEBUG\n")
    file (APPEND ${CMAKE_BINARY_DIR}/${par_name} "obj-m += ${par_name}.o\n\n")

    set_target_properties(module-${par_name}-debug-build PROPERTIES KERNEL_VERSION_MAJOR ${par_kernel_maj})
    set_target_properties(module-${par_name}-debug-build PROPERTIES KERNEL_VERSION_MINOR ${par_kernel_min})
    set_target_properties(module-${par_name}-debug-build PROPERTIES KERNEL_VERSION       ${par_kernel_ver})

    set_target_properties(module-${par_name}-debug-clean PROPERTIES KERNEL_VERSION_MAJOR ${par_kernel_maj})
    set_target_properties(module-${par_name}-debug-clean PROPERTIES KERNEL_VERSION_MINOR ${par_kernel_min})
    set_target_properties(module-${par_name}-debug-clean PROPERTIES KERNEL_VERSION       ${par_kernel_ver})

    set_target_properties(module-${par_name}-debug-install PROPERTIES KERNEL_VERSION_MAJOR ${par_kernel_maj})
    set_target_properties(module-${par_name}-debug-install PROPERTIES KERNEL_VERSION_MINOR ${par_kernel_min})
    set_target_properties(module-${par_name}-debug-install PROPERTIES KERNEL_VERSION       ${par_kernel_ver})
endfunction()

function (add_kernel_module par_name par_kernel)
    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_kernel})
        message("[Klever] Kernel \"${par_kernel}\" not exist at directory ${PRESET_KERNEL_DIR}.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    get_target_property(par_kernel_ver kernel-${par_kernel}-build KERNEL_VERSION)
    get_target_property(par_kernel_maj kernel-${par_kernel}-build KERNEL_VERSION_MAJOR)
    get_target_property(par_kernel_min kernel-${par_kernel}-build KERNEL_VERSION_MINOR)
    add_custom_command (
            OUTPUT            ${par_name}.ko
            COMMAND           cp ${CMAKE_BINARY_DIR}/${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND           make -C ${CMAKE_SOURCE_DIR}/kernel/${par_kernel} M=${CMAKE_SOURCE_DIR} modules
            COMMAND           rm ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND           mv ${CMAKE_SOURCE_DIR}/${par_name}.ko ${CMAKE_BINARY_DIR}/${par_name}.ko
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            DEPENDS           ${CMAKE_BINARY_DIR}/${par_name}
            VERBATIM
    )

    add_custom_target (module-${par_name}-build DEPENDS ${par_name}.ko)
    add_custom_target (
            module-${par_name}-clean
            COMMAND cp ${CMAKE_BINARY_DIR}/${par_name} ${CMAKE_SOURCE_DIR}/Kbuild
            COMMAND make -C ${CMAKE_SOURCE_DIR}/kernel/${par_kernel} M=${CMAKE_SOURCE_DIR} clean
            COMMAND rm ${CMAKE_SOURCE_DIR}/Kbuild
    )

    file (REMOVE ${CMAKE_BINARY_DIR}/${par_name})
    file (APPEND ${CMAKE_BINARY_DIR}/${par_name} "obj-m += ${par_name}.o\n\n")

    set_target_properties(module-${par_name}-build PROPERTIES KERNEL_VERSION_MAJOR ${par_kernel_maj})
    set_target_properties(module-${par_name}-build PROPERTIES KERNEL_VERSION_MINOR ${par_kernel_min})
    set_target_properties(module-${par_name}-build PROPERTIES KERNEL_VERSION       ${par_kernel_ver})

    set_target_properties(module-${par_name}-clean PROPERTIES KERNEL_VERSION_MAJOR ${par_kernel_maj})
    set_target_properties(module-${par_name}-clean PROPERTIES KERNEL_VERSION_MINOR ${par_kernel_min})
    set_target_properties(module-${par_name}-clean PROPERTIES KERNEL_VERSION       ${par_kernel_ver})

    set_target_properties(module-${par_name}-install PROPERTIES KERNEL_VERSION_MAJOR ${par_kernel_maj})
    set_target_properties(module-${par_name}-install PROPERTIES KERNEL_VERSION_MINOR ${par_kernel_min})
    set_target_properties(module-${par_name}-install PROPERTIES KERNEL_VERSION       ${par_kernel_ver})
endfunction()

function   (kernel_module_include par_name par_path)
    if   (NOT EXISTS ${CMAKE_BINARY_DIR}/${par_name})
        message("[Klever] No Module ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    file(APPEND ${CMAKE_BINARY_DIR}/${par_name} "ccflags-y += -I${par_path}\n\n")
endfunction()

function   (kernel_module_definition par_name par_def)
    if   (NOT EXISTS ${CMAKE_BINARY_DIR}/${par_name})
        message("[Klever] No Module ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    file(APPEND ${CMAKE_BINARY_DIR}/${par_name} "ccflags-y += -D${par_def}\n\n")
endfunction()

function     (kernel_module_source par_name)
    if   (NOT EXISTS ${CMAKE_BINARY_DIR}/${par_name})
        message("[Klever] No Module ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    foreach  (MOD_SRC IN LISTS ARGN)
        file (APPEND ${CMAKE_BINARY_DIR}/${par_name} "${par_name}-objs += \\\n")
        get_target_property(MOD_SRC_LIST ${MOD_SRC} KERNEL_SOURCE)
        get_target_property(MOD_SRC_DIR  ${MOD_SRC} KERNEL_SOURCE_DIR)
        foreach   (SRC ${MOD_SRC_LIST})
            file(RELATIVE_PATH MOD_DIR ${CMAKE_SOURCE_DIR} ${MOD_SRC_DIR})
            file(APPEND ${CMAKE_BINARY_DIR}/${par_name} "\t${MOD_DIR}/${SRC}\\\n")
        endforeach()
        file (APPEND ${CMAKE_BINARY_DIR}/${par_name} "\n\n")
    endforeach ()
    file  (APPEND ${CMAKE_BINARY_DIR}/${par_name} "\n\n")
endfunction()