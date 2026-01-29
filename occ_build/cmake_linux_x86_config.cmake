# Linux x86_64 specific configuration for Open CASCADE
# Include the base headless configuration
include(${CMAKE_CURRENT_LIST_DIR}/cmake_headless_config.cmake)

# Linux x86_64 architecture
set(CMAKE_SYSTEM_PROCESSOR "x86_64" CACHE STRING "Target processor")

# GCC/Clang optimization flags for x86_64
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG -march=x86-64 -mtune=generic" CACHE STRING "C release flags")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG -march=x86-64 -mtune=generic" CACHE STRING "C++ release flags")

# Use standard C++ library
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11" CACHE STRING "C++ flags")

# Position Independent Code for static libraries that might be linked into shared libraries
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "Build position independent code")
