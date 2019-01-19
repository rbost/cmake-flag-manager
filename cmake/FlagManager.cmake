cmake_minimum_required(VERSION 3.0)

include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

function(save_compile_option)
    # Save the CMAKE_REQUIRED_QUIET variable
    set(_CMAKE_REQUIRED_QUIET ${CMAKE_REQUIRED_QUIET})
    # Silence CMake's logging for check_c_compiler_flag
    set(CMAKE_REQUIRED_QUIET TRUE)

    foreach(_flag ${ARGN})

        set(FLAG_VARNAME "COMPILE_FLAG${_flag}_SUPPORTED")
        set(CFLAG_VARNAME "C_${FLAG_VARNAME}")
        set(CXXFLAG_VARNAME "CXX_${FLAG_VARNAME}")

        check_c_compiler_flag(${_flag} ${CFLAG_VARNAME})
        if(${CFLAG_VARNAME})
            list(APPEND SAVED_CFLAG_LIST ${_flag})
        endif()

        check_cxx_compiler_flag(${_flag} ${CXXFLAG_VARNAME})
        if(${CXXFLAG_VARNAME})
            list(APPEND SAVED_CXXFLAG_LIST ${_flag})
        endif()

    endforeach(_flag ${ARGN})

    set(SAVED_CFLAG_LIST ${SAVED_CFLAG_LIST} PARENT_SCOPE)
    set(SAVED_CXXFLAG_LIST ${SAVED_CXXFLAG_LIST} PARENT_SCOPE)

    # reset CMAKE_REQUIRED_QUIET
    set(CMAKE_REQUIRED_QUIET ${_CMAKE_REQUIRED_QUIET})

endfunction(save_compile_option)

function(target_apply_saved_options)
    # message(STATUS "C compiler flags: ${SAVED_CFLAG_LIST}")

    # message(STATUS "C++ compiler flags: ${SAVED_CXXFLAG_LIST}")
    foreach(_target ${ARGN})

        target_compile_options(
            ${_target}
            PRIVATE $<$<COMPILE_LANGUAGE:C>:${SAVED_CFLAG_LIST}>
        )
        target_compile_options(
            ${_target}
            PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${SAVED_CXXFLAG_LIST}>
        )
    endforeach()
endfunction(target_apply_saved_options)
