if   (NOT DEFINED PRESET_BUSYBOX)
    message("[Klever] Target Busybox Version Not Defined")
    message("[Klever] Set Busybox Version to 1.31.0.")
    set    (PRESET_BUSYBOX 1.31.0)
endif()

if   (PRESET_BUSYBOX EQUAL 1.31.0)
    set(PRESET_BUSYBOX_URL "https://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-${PRESET_BUILD_ARCH}")
elseif (PRESET_BUSYBOX EQUAL 1.35.0)
    set(PRESET_BUSYBOX_URL "https://www.busybox.net/downloads/binaries/1.35.0-${PRESET_BUILD_ARCH}-linux-musl/busybox")
else ()
    message("[Klever] This Busybox version (${PRESET_BUSYBOX}) is not supported.")
    message("[Klever] Try Other Version of Busybox.")
    message(SEND_ERROR "[Klever] Setup Aborted")
endif()

if   (NOT DEFINED PRESET_KERNEL_DIR)
    set  (PRESET_KERNEL_DIR "${CMAKE_SOURCE_DIR}/kernel")

endif()

if   (NOT DEFINED PRESET_KERNEL_TARGET_DIR)
    set  (PRESET_KERNEL_TARGET_DIR "${CMAKE_SOURCE_DIR}/kernel_target")
endif()

if   (NOT EXISTS ${PRESET_KERNEL_DIR})
    file(MAKE_DIRECTORY ${PRESET_KERNEL_DIR})
endif()

if   (NOT EXISTS ${PRESET_KERNEL_TARGET_DIR})
    file(MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR})
endif()