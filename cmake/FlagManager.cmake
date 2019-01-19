# MIT License

# Copyright (c) 2019 Raphael Bost

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


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
