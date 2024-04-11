define_property(TARGET PROPERTY KLEVER_SOURCE_PATH BRIEF_DOCS "Kernel Source Directory" FULL_DOCS "Kernel Source Directory")
define_property(TARGET PROPERTY KLEVER_SOURCE      BRIEF_DOCS "Kernel Source"           FULL_DOCS "Kernel Source")

function   (add_kernel_source NAME)
    file       (RELATIVE_PATH PATH ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
    add_library(${NAME} STATIC  ${ARGN})
    foreach    (SRC IN LISTS ARGN)
        string (FIND ${SRC} ".h" RES REVERSE)
        if   (NOT RES EQUAL -1)
            continue()
        endif()
        string (REPLACE ".c" ".o" SRC ${SRC})
        list   (APPEND SRC_LIST       ${SRC})
    endforeach ()
    set_target_properties(${NAME} PROPERTIES KLEVER_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
    set_target_properties(${NAME} PROPERTIES KLEVER_SOURCE      "${SRC_LIST}")
endfunction()