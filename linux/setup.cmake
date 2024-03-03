if   (NOT DEFINED PRESET_BUSYBOX)
    message("[Klever] Target Busybox Version Not Defined")
    message("[Klever] Set Busybox Version to 1.31.0.")
    set    (PRESET_BUSYBOX 1.31.0)
endif()

if   (PRESET_BUSYBOX EQUAL 1.31.0)
    set    (PRESET_BUSYBOX_URL "https://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-${PRESET_BUILD_ARCH}")
elseif (${PRESET_BUSYBOX} EQUAL 1.35.0)
    set    (PRESET_BUSYBOX_URL "https://www.busybox.net/downloads/binaries/1.35.0-${PRESET_BUILD_ARCH}-linux-musl/busybox")
else ()
    message("[Klever] This Busybox version (${PRESET_BUSYBOX}) is not supported.")
    message("[Klever] Try Other Version of Busybox.")
    message(SEND_ERROR "[Klever] Setup Aborted")
endif()

string (REPLACE "\n" "" PRESET_BUSYBOX_URL "${PRESET_BUSYBOX_URL}")
message("[Klever] BusyBox Download URL : ${PRESET_BUSYBOX_URL}")
set    (PRESET_BUSYBOX_URL ${PRESET_BUSYBOX_URL} PARENT_SCOPE)

if    (EXISTS /usr/bin/konsole)
    message("[Klever] Found KDE Konsole.")
    set    (PRESET_TERMINAL      "konsole"    PARENT_SCOPE)
    set    (PRESET_TERMINAL_DIR  "--workdir " PARENT_SCOPE)
    set    (PRESET_TERMINAL_EXEC "--hold -e"  PARENT_SCOPE)
elseif(EXISTS /usr/bin/gnome-terminal)
    message("[Klever] Found GNOME gnome-terminal.")
    set    (PRESET_TERMINAL "gnome-terminal"            PARENT_SCOPE)
    set    (PRESET_TERMINAL_DIR  "--working-directory=" PARENT_SCOPE)
    set    (PRESET_TERMINAL_EXEC "-e"                   PARENT_SCOPE)
endif ()

if   (NOT DEFINED PRESET_KERNEL_DIR)
    set  (PRESET_KERNEL_DIR "${CMAKE_SOURCE_DIR}/kernel" PARENT_SCOPE)
endif()

if   (NOT DEFINED PRESET_KERNEL_TARGET_DIR)
    set  (PRESET_KERNEL_TARGET_DIR "${CMAKE_SOURCE_DIR}/kernel_target" PARENT_SCOPE)
endif()

if   (NOT EXISTS ${PRESET_KERNEL_DIR})
    file(MAKE_DIRECTORY ${PRESET_KERNEL_DIR})
endif()

if   (NOT EXISTS ${PRESET_KERNEL_TARGET_DIR})
    file(MAKE_DIRECTORY ${PRESET_KERNEL_TARGET_DIR})
endif()

if   (NOT DEFINED PRESET_KERNEL_HEADER)
    list(APPEND PRESET_KERNEL_HEADER "/usr/src/kernels/${CMAKE_HOST_SYSTEM_VERSION}/include")
    list(APPEND PRESET_KERNEL_HEADER "/usr/src/linux-headers-${CMAKE_HOST_SYSTEM_VERSION}/include")
    set (PRESET_KERNEL_HEADER ${PRESET_KERNEL_HEADER} PARENT_SCOPE)
endif()

define_property(TARGET PROPERTY KERNEL_VERSION_MAJOR BRIEF_DOCS "Kernel Major Version"    FULL_DOCS "Kernel Major Version")
define_property(TARGET PROPERTY KERNEL_VERSION_MINOR BRIEF_DOCS "Kernel Minor Version"    FULL_DOCS "Kernel Minor Version")
define_property(TARGET PROPERTY KERNEL_VERSION       BRIEF_DOCS "Kernel Version"          FULL_DOCS "Kernel Version")

define_property(TARGET PROPERTY KERNEL_SOURCE_DIR    BRIEF_DOCS "Kernel Source Directory" FULL_DOCS "Kernel Source Directory")
define_property(TARGET PROPERTY KERNEL_SOURCE        BRIEF_DOCS "Kernel Source List"      FULL_DOCS "Kernel Source List")