if   (NOT DEFINED PRESET_BUILD_ARCH)
    message("[Klever] Target Architecture not defined.")
    message("[Klever] Add -DPRESET_BUILD_ARCH=(Target Architecture) at CMake Command to avoid this problem.")
    message(SEND_ERROR "[Klever] Setup Aborted")
endif()

if (UNIX AND NOT APPLE)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/linux/setup.cmake)
endif()

ProcessorCount (PRESET_JOB_COUNT)