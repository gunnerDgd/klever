if (UNIX AND NOT APPLE)
    if   (NOT DEFINED PRESET_BUILD_ARCH)
        set    (PRESET_BUILD_ARCH)
        message("[Klever] Target Architecture not defined.")
        message("[Klever] Assume Target Architecture as same as host's one.")

        execute_process(COMMAND uname -m OUTPUT_VARIABLE    PRESET_BUILD_ARCH)
        string         (REPLACE "\n" "" PRESET_BUILD_ARCH ${PRESET_BUILD_ARCH})
        message        ("[Klever] Target Architecture : ${PRESET_BUILD_ARCH}")
    endif()
    include(${CMAKE_CURRENT_LIST_DIR}/linux/setup.cmake)
endif()
include        (ProcessorCount)
ProcessorCount (PRESET_JOB_COUNT)
