function (add_kernel_feature_with_symbol par_name par_kernel)
    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_kernel})
        message("[Klever] Kernel \"${par_kernel}\" not exist at directory ${PRESET_KERNEL_DIR}.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    add_custom_target                                            (
            ${par_name}-build
            COMMAND sudo -S make -j${PRESET_JOB_COUNT} vmlinux
            COMMAND sudo -S make -j${PRESET_JOB_COUNT} bzImage
            WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_kernel}
    )

    add_custom_target                                                (
            ${par_name}-clean
            COMMAND sudo -S make -j${PRESET_JOB_COUNT} clean
            WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_kernel}
    )
    # Create Target Feature Directory
    set  (FEATURE_DIR "${PRESET_KERNEL_DIR}/${par_kernel}/klever/${par_name}")
    if   (NOT EXISTS "${FEATURE_DIR}")
        file (MAKE_DIRECTORY ${FEATURE_DIR})
    endif()

    # Generate Kbuild File to build kernel embedded feature.
    # with_symbol will generate debug symbol required for GDB execution.
    file (REMOVE ${FEATURE_DIR}/Kbuild)
    file (APPEND ${FEATURE_DIR}/Kbuild "ccflags-y += -g -DDEBUG\n")
    file (APPEND ${FEATURE_DIR}/Kbuild "obj-y     += ${par_name}.o\n\n")

    # Add obj-y to the Kernel Build Script (${par_kernel}/Kbuild)
    file  (READ ${PRESET_KERNEL_DIR}/${par_kernel}/Kbuild CONTENTS)
    string(FIND "${CONTENTS}" "obj-y += klever/${par_name}" res REVERSE)
    if    (res EQUAL -1)
        file (APPEND ${PRESET_KERNEL_DIR}/${par_kernel}/Kbuild "\nobj-y += klever/${par_name}/\n")
    endif ()
endfunction()

function (add_kernel_feature par_name par_kernel)
    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_kernel})
        message("[Klever] Kernel \"${par_kernel}\" not exist at directory ${PRESET_KERNEL_DIR}.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    add_custom_target (
            ${par_name}-build
            COMMAND sudo -S make -j${PRESET_JOB_COUNT} vmlinux
            COMMAND sudo -S make -j${PRESET_JOB_COUNT} bzImage
            WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_kernel}
    )

    add_custom_target (
            ${par_name}-clean
            COMMAND sudo -S make -j${PRESET_JOB_COUNT} clean
            WORKING_DIRECTORY ${PRESET_KERNEL_DIR}/${par_kernel}
    )

    # Create Target Feature Directory
    set  (FEATURE_DIR "${PRESET_KERNEL_DIR}/${par_kernel}/klever/${par_name}")
    if   (NOT EXISTS  "${FEATURE_DIR}")
        file (MAKE_DIRECTORY ${FEATURE_DIR})
    endif()

    # Generate Kbuild File to build kernel embedded feature.
    file (REMOVE ${FEATURE_DIR}/Kbuild)
    file (APPEND ${FEATURE_DIR}/Kbuild "obj-y     += ${par_name}.o\n\n")

    file  (READ ${PRESET_KERNEL_DIR}/${par_kernel}/Kbuild CONTENTS)
    string(FIND ${CONTENTS} "obj-y += klever/${par_name}" res REVERSE)
    if    (res EQUAL -1)
        file (APPEND ${PRESET_KERNEL_DIR}/${par_kernel}/Kbuild "\nobj-y += klever/${par_name}\n")
    endif ()
endfunction()


function   (kernel_feature_include par_name par_kernel par_path)
    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_kernel})
        message("[Klever] Kernel \"${par_kernel}\" not exist at directory ${PRESET_KERNEL_DIR}.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    set  (FEATURE_DIR "${PRESET_KERNEL_DIR}/${par_kernel}/klever/${par_name}")
    if   (NOT EXISTS ${FEATURE_DIR})
        message("[Klever] No Feature ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    file(APPEND ${PRESET_KERNEL_DIR}/${par_kernel}/klever/${par_name}/Kbuild "ccflags-y += -I${par_path}\n\n")
endfunction()

function   (kernel_feature_definition par_name par_kernel par_def)
    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_kernel})
        message("[Klever] Kernel \"${par_kernel}\" not exist at directory ${PRESET_KERNEL_DIR}.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    set  (FEATURE_DIR "${PRESET_KERNEL_DIR}/${par_kernel}/klever/${par_name}")
    if   (NOT EXISTS ${FEATURE_DIR})
        message("[Klever] No Feature ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    file(APPEND ${PRESET_KERNEL_DIR}/${par_kernel}/klever/${par_name}/Kbuild "ccflags-y += -D${par_def}\n\n")
endfunction()

function     (kernel_feature_source par_name par_kernel)
    if   (NOT EXISTS ${PRESET_KERNEL_DIR}/${par_kernel})
        message("[Klever] Kernel \"${par_kernel}\" not exist at directory ${PRESET_KERNEL_DIR}.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    set  (FEATURE_DIR "${PRESET_KERNEL_DIR}/${par_kernel}/klever/${par_name}")
    if   (NOT EXISTS ${FEATURE_DIR})
        message("[Klever] No Feature ${par_name} Defined.")
        message("[Klever] Abort CMake Generator Process")
        message(SEND_ERROR "Abort")
    endif()

    foreach  (MOD_SRC IN LISTS ARGN)
        file (APPEND ${FEATURE_DIR}/Kbuild "${par_name}-y += \\\n")
        get_target_property(MOD_SRC_LIST ${MOD_SRC} KERNEL_SOURCE)
        get_target_property(MOD_SRC_DIR  ${MOD_SRC} KERNEL_SOURCE_DIR)
        foreach   (SRC ${MOD_SRC_LIST})
            file(RELATIVE_PATH MOD_DIR ${FEATURE_DIR} ${MOD_SRC_DIR})
            file(APPEND ${FEATURE_DIR}/Kbuild "\t${MOD_DIR}/${SRC}\\\n")
        endforeach()
        file (APPEND ${FEATURE_DIR}/Kbuild "\n\n")
    endforeach ()
    file  (APPEND ${FEATURE_DIR}/Kbuild "\n\n")
endfunction()