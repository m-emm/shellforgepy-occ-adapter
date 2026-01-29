# macOS ARM64 specific configuration for Open CASCADE
# Include the base headless configuration
include(${CMAKE_CURRENT_LIST_DIR}/cmake_headless_config.cmake)

# macOS ARM64 architecture
set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "Build for Apple Silicon")

# macOS deployment target (adjust as needed)
set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "Minimum macOS version")

# Optional: Use libc++ explicitly (standard on macOS)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++" CACHE STRING "C++ flags")

# Optimization flags for Apple Silicon
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG -mcpu=apple-m1" CACHE STRING "C release flags")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG -mcpu=apple-m1" CACHE STRING "C++ release flags")
