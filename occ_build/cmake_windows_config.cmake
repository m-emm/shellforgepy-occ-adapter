# Windows x64 specific configuration for Open CASCADE
# Include the base headless configuration
include(${CMAKE_CURRENT_LIST_DIR}/cmake_headless_config.cmake)

# Windows x64 architecture
set(CMAKE_SYSTEM_PROCESSOR "x64" CACHE STRING "Target processor")

# Use static runtime library for static builds
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "MSVC runtime library")

# Windows-specific compile options
if(MSVC)
    # Optimization flags
    set(CMAKE_C_FLAGS_RELEASE "/O2 /Ob2 /DNDEBUG" CACHE STRING "C release flags")
    set(CMAKE_CXX_FLAGS_RELEASE "/O2 /Ob2 /DNDEBUG" CACHE STRING "C++ release flags")
    
    # Disable specific warnings that OCCT may trigger
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W3 /wd4290 /wd4018 /wd4244 /wd4267" CACHE STRING "C++ flags")
    
    # Enable multi-processor compilation
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP" CACHE STRING "C++ flags")
    
    # Large address aware (for 32-bit builds, harmless for 64-bit)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE" CACHE STRING "Linker flags")
endif()

# Position Independent Code not needed on Windows
set(CMAKE_POSITION_INDEPENDENT_CODE OFF CACHE BOOL "Not needed on Windows")
