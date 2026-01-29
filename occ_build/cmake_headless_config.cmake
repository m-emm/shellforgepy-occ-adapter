# CMake configuration for headless Open CASCADE build
# This file can be used with: cmake -C cmake_headless_config.cmake <source_dir>

# Build configuration
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type")
set(BUILD_LIBRARY_TYPE "Static" CACHE STRING "Build static libraries")

# Disable GUI and visualization components
set(USE_TK OFF CACHE BOOL "Disable Tcl/Tk toolkit")
set(USE_FREETYPE OFF CACHE BOOL "Disable FreeType font rendering")
set(USE_XLIB OFF CACHE BOOL "Disable X11 support")
set(USE_OPENGL OFF CACHE BOOL "Disable OpenGL")
set(USE_GLES2 OFF CACHE BOOL "Disable OpenGL ES 2.0")
set(USE_FREEIMAGE OFF CACHE BOOL "Disable FreeImage")
set(USE_RAPIDJSON OFF CACHE BOOL "Disable RapidJSON")
set(USE_DRACO OFF CACHE BOOL "Disable Draco")

# Disable modules that require visualization
set(BUILD_MODULE_Draw OFF CACHE BOOL "Disable Draw test harness")
set(BUILD_MODULE_Visualization OFF CACHE BOOL "Disable visualization modules")
set(BUILD_MODULE_ApplicationFramework OFF CACHE BOOL "Disable application framework")

# Disable documentation and samples
set(BUILD_DOC_Overview OFF CACHE BOOL "Disable documentation")
set(INSTALL_TEST_CASES OFF CACHE BOOL "Don't install test cases")
set(INSTALL_SAMPLES OFF CACHE BOOL "Don't install samples")

# Enable only core modeling and data exchange modules
# These modules will be built automatically as they don't depend on GUI:
# - FoundationClasses (TKernel, TKMath)
# - ModelingData (TKG2d, TKG3d, TKGeomBase, TKBRep, TKTopAlgo)
# - ModelingAlgorithms (TKPrim, TKBool, TKBO, TKFillet, TKOffset, etc.)
# - DataExchange (TKSTEP, TKIGES, TKSTL, etc.)
# - ShapeHealing
