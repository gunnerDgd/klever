function   (enable_busybox VERSION)
    string (APPEND PATH    ${KLEVER_PATH_TOOLS}/busybox)
    string (APPEND NAME    "busybox-${VERSION}")
    string (APPEND ARCHIVE "${NAME}.tar.bz2")
    string (APPEND URL     "https://busybox.net/downloads/${ARCHIVE}")

    if   (EXISTS /usr/bin/konsole)
        string (APPEND CONF "konsole --workdir ${PATH} --hold -e ")
        string (APPEND CONF "make menuconfig HOSTCC=")
        string (APPEND CONF "\"gcc -Wno-implicit-int\" ")
        string (APPEND CONF "-j${KLEVER_JOB}")
    endif()

    if   (EXISTS ${KLEVER_PATH_TOOLS}/busybox)
        if   (NOT EXISTS ${KLEVER_PATH_TOOLS}/busybox/.config)
            execute_process(COMMAND /bin/bash    -c ${CONF}       WORKING_DIRECTORY ${PATH})
            execute_process(COMMAND make busybox -j ${KLEVER_JOB} WORKING_DIRECTORY ${PATH})
        endif()

        if    (NOT EXISTS ${KLEVER_PATH_TOOLS}/busybox/busybox)
            return()
        endif ()

        set   (KLEVER_TOOLS_BUSYBOX ON PARENT_SCOPE)
        return()
    endif()

    file (DOWNLOAD ${URL} ${KLEVER_PATH_TOOLS}/${ARCHIVE})
    if   (RES EQUAL 0)
        message("[Klever] Failed to Download Busybox (${KLEVER_PATH_TOOLS}/${ARCHIVE})")
        message(SEND_ERROR)
    endif()
    execute_process(COMMAND tar -xvf ${ARCHIVE} WORKING_DIRECTORY ${KLEVER_PATH_TOOLS})
    if   (NOT EXISTS ${KLEVER_PATH_TOOLS}/${NAME})
        message("[Klever] Failed to Decompress Busybox")
        message(SEND_ERROR)
    endif()

    file  (RENAME ${KLEVER_PATH_TOOLS}/${NAME} ${KLEVER_PATH_TOOLS}/busybox)
    file  (REMOVE ${KLEVER_PATH_TOOLS}/${ARCHIVE})

    execute_process(COMMAND /bin/bash    -c ${CONF}       WORKING_DIRECTORY ${PATH})
    execute_process(COMMAND make busybox -j ${KLEVER_JOB} WORKING_DIRECTORY ${PATH})
    set            (KLEVER_TOOLS_BUSYBOX ON PARENT_SCOPE)
endfunction()