if   (NOT DEFINED PRESET_BUILD_ARCH)
    message("[Klever] Target Architecture not defined.")
    message("[Klever] Assume Target Architecture as same as host's one.")

    execute_process(COMMAND uname -m OUTPUT_VARIABLE PRESET_BUILD_ARCH)
    message        ("[Klever] Target Architecture : ${PRESET_BUILD_ARCH}")
endif()

if (UNIX AND NOT APPLE)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/linux/setup.cmake)
endif()

ProcessorCount (PRESET_JOB_COUNT)