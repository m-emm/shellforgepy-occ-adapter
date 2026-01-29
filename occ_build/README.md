# Open CASCADE Headless Build

This directory contains scripts and configuration files for building Open CASCADE Technology (OCCT) in headless mode without GUI, X11, or OpenGL dependencies.

## Quick Start

### macOS ARM64

```bash
cd occ_build
./build_occt_macos_arm.sh
```

This will:
1. Clone OCCT 7.9 from GitHub
2. Configure a headless build without GUI dependencies
3. Build static libraries optimized for Apple Silicon
4. Install to `occ_build/install/`

### Linux x86_64

**macOS**:
- **Headers**: `occ_build/install/include/opencascade/`
- **Libraries**: `occ_build/install/lib/`
- **CMake config**: `occ_build/install/lib/cmake/opencascade/`

**Linux**:
- **Headers**: `occ_build/install_linux/include/opencascade/`
- **Libraries**: `occ_build/install_linux/lib/`
- **CMake config**: `occ_build/install_linux
```bash
cd occ_build
./build_occt_linux_x86.sh
```

This will:
1. Clone OCCT 7.9 from GitHub (if not already cloned)
2. Configure a headless build for Linux x86_64
3. Build static libraries
4. Install to `occ_build/install_linux/`

**Requirements**: CMake, GCC/Clang, git, ninja-build

#### Docker Build (Linux x86_64)

If you're on macOS or don't want to install build tools locally:

```bash
cd occ_build
./build_occt_linux_docker.sh
```

This will:
1. Clone OCCT 7.9 on the host (if not already cloned)
2. Start an Ubuntu 22.04 Docker container
3. Install build dependencies inside the container
4. Mount the workspace directory into the container
5. Build Open CASCADE inside the container
6. Output build results to the host filesystem
7. Install to `occ_build/install_linux/`

**Requirements**: Docker

### Windows x64

#### Local Windows Build

**PowerShell (recommended)**:
```powershell
cd occ_build
.\build_occt_windows.ps1
```

**Command Prompt**:
```cmd
cd occ_build
build_occt_windows.bat
```

This will:
1. Clone OCCT 7.9 from GitHub (if not already cloned)
2. Configure a headless build for Windows x64
3. Build static libraries using MSVC
4. Install to `occ_build/install_windows/`

**Requirements**: CMake, Visual Studio 2019/2022 (or Build Tools), Git

#### GitHub Actions Build

For CI/CD, see the provided workflow example: [github-actions-example.yml](github-actions-example.yml)

The workflow:
- Uses `windows-latest` runner (includes VS 2022, CMake, Git)
- Caches source code between builds
- Uploads build artifacts
- Verifies build completeness

**Key features**:
- ✅ Runs on GitHub-hosted Windows runners
- ✅ Automatic MSVC setup
- ✅ Parallel compilation
- ✅ Artifact upload for downloads
- ✅ Build verification

## Build Output

After successful build:
- **Headers**: `occ_build/install/include/opencascade/`
- **Libraries**: `occ_build/install/lib/`
- **CMake config**: `occ_build/install/lib/cmake/opencascade/`

## What's Included (Headless Mode)

The headless build includes these OCCT modules:

- **FoundationClasses**: Core utilities, math, collections
- **ModelingData**: Geometry and topology (curves, surfaces, shapes)
- **ModelingAlgorithms**: Boolean operations, filleting, offsetting, primitives
- **DataExchange**: STEP, IGES, STL, OBJ import/export
- **ShapeHealing**: Shape repair and optimization

## What's Excluded

- **Visualization**: 3D rendering, OpenGL, display
- **ApplicationFramework**: GUI application support (OCAF)
- **Draw**: Interactive test harness (requires Tcl/Tk)
- **X11/OpenGL dependencies**: No windowing or graphics

## Manual Build with CMake

You can also build manually using the configuration files:

```bash
# Clone OCCT
git clone --branch OCCT-7.9 --depth 1 https://github.com/Open-Cascade-SAS/OCCT.git occt

# Configure with preset
mkdir build && cd build
cmake ../occt -C ../cmake_macos_arm_config.cmake \
  -DCMAKE_INSTALL_PREFIX=../install

# Build (using all cores)
cmake --build . --config Release --parallel $(sysctl -n hw.ncpu)

# Install
cmakcmake_linux_x86_config.cmake**: Linux x86_64 specific settings
- **build_occt_macos_arm.sh**: Automated build script for macOS ARM64
- **build_occt_linux_x86.sh**: Automated build script for Linux x86_64
- **build_occt_linux_docker.sh**: Docker wrapper for Linux x86_64 build
```

## Configuration Files

- **cmake_headless_config.cmake**: Base configuration for headless builds
- **cmake_macos_arm_config.cmake**: macOS ARM64 specific settings
- **build_occt_macos_arm.sh**: Automated build script for macOS ARM64

## Requirements

**macOS**:
- CMake 3.16 or later
- Xcode Command Line Tools (Clang)
- Git

**Linux**:
- CMake 3.16 or later
- GCC or Clang
- Git
- ninja-build (optional, for faster builds)

**Windows**:
- CMake 3.16 or later
- Visual Studio 2019/2022 or MSVC Build Tools
- Git
- PowerShell 5.1 or later

**Docker** (for Linux Docker build):
- Docker Desktop (macOS/Windows) or Docker Engine (Linux)

## Using in Your Project

After building, link against the OCCT libraries in your CMakeLists.txt:

```cmake
find_package(OpenCASCADE REQUIRED PATHS ${CMAKE_CURRENT_SOURCE_DIR}/occ_build/install)
include_directories(${OpenCASCADE_INCLUDE_DIR})
target_link_libraries(your_target ${OpenCASCADE_LIBRARIES})
```

Or set the install directory in your environment:

```bash
export OpenCASCADE_DIR=/path/to/occ_build/install/lib/cmake/opencascade
```

## Troubleshooting
Docker Build Details

The Docker build script (`build_occt_linux_docker.sh`) uses volume mounting to share data between host and container:

```bash
docker run --rm \
  -v "${SCRIPT_DIR}:/workspace" \  # Mount entire occ_build directory
  -w /workspace \                   # Set working directory
  ubuntu:22.04 \
  bash -c "install deps && build"
```

**Benefits**:
- ✅ Consistent build environment
- ✅ No need to install build tools on host
- ✅ Build output accessible on host filesystem
- ✅ Source code persists between builds
- ✅ Works on any platform with Docker

**What's mounted**:
- Source code: `occt/` (cloned on host, reused by container)
- Build directory: `build_linux/` (created by container, accessible on host)
- Install directory: `install_linux/` (created by container, accessible on host)

## Platform Support

Currently configured for:
- ✅ macOS ARM64 (Apple Silicon)
- ✅ Linux x86_64 (native and Docker)

To add support for other platforms, create similar configuration files:
- `cmake_macos_x86_config.cmake` for Intel Macs
- `cmake_linux_arm_config.cmake` for Linux ARM64
- Edit the CMake configuration files to enable/disable specific modules

## Platform Support

Currently configured for:
- ✅ macOS ARM64 (Apple Silicon)

To add support for other platforms, create similar configuration files:
- `cmake_macos_x86_config.cmake` for Intel Macs
- `cmake_linux_config.cmake` for Linux
- `cmake_windows_config.cmake` for Windows
