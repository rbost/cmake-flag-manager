# CMake Flag Manager

CMake module to easily play with compile flags by seamlessly detecting their availability and carefully setting them target by target.

## Include into your project

To use [FlagManager.cmake](cmake/FlagManager.cmake), simply add this repository as git submodule into your own repository

```Shell
mkdir externals
git submodule add https://github.com/rbost/cmake-flag-manager.git
```

and adding `externals/cmake-flag-manager/cmake` to your `CMAKE_MODULE_PATH`

```CMake
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/externals/cmake-flag-manager/cmake")
```

You can also simply copy the [FlagManager.cmake](cmake/FlagManager.cmake) file in your repo. However, these will not be updated without re-copying the file.

Finally, include the `FlagManager` package, say in the root CMake file, by add the following lines:
```CMake
find_package(FlagManager)
```

## Usage

The `FlagManager` package defines two functions:

*   `save_compile_option` to add a new compile option. This function will check if the option is available for either your C or your C++ compiler, and save it to a language-specific list of compile options. The function can be passed a list of options, in which case, the availability of the options will be tested consecutively, in the given order:
```CMake
save_compile_option(-Wall -Wextra)
```

*   `target_apply_saved_options` to apply the saved options to a list of targets:
```CMake
target_apply_saved_options(MyLib MyExe)
```

## License

This CMake module is released under the MIT license. See the [LICENSE](LICENSE) file for more information.




