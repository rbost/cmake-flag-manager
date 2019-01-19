cmake_minimum_required(VERSION 3.0)

project(
    cmake-flag-manager DESCRIPTION
    "A manager for C/C++ compiler flags in CMake"
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(FlagManager)

save_compile_option(-Wall -Wextra -Wgibberish)

add_library(test_target src/source.cpp src/source.c)

target_apply_saved_options(test_target)