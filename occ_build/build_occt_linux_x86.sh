#!/bin/bash
# Build script for Open CASCADE on Linux x86_64

set -euo pipefail
trap 'echo "Script $0 failed at line $LINENO" >&2' ERR

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPT_FULLPATH="$(realpath "$0")"

echo "Running ${SCRIPT_FULLPATH} with args: $@"

# Configuration
OCCT_VERSION="OCCT-7.9"
OCCT_SRC_DIR="${SCRIPT_DIR}/occt"
BUILD_DIR="${SCRIPT_DIR}/build_linux"
INSTALL_DIR="${SCRIPT_DIR}/install_linux"
NUM_CORES=$(nproc)

echo "==> Cleaning previous build..."
rm -rf ${BUILD_DIR}
rm -rf ${INSTALL_DIR}

# Only clone if source doesn't exist (useful for Docker builds)
if [ ! -d "${OCCT_SRC_DIR}" ]; then
    echo "==> Cloning Open CASCADE ${OCCT_VERSION}..."
    git clone --branch ${OCCT_VERSION} --depth 1 https://github.com/Open-Cascade-SAS/OCCT.git ${OCCT_SRC_DIR}
else
    echo "==> Using existing source directory: ${OCCT_SRC_DIR}"
fi

echo "==> Creating build directory..."
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

echo "==> Configuring headless build for Linux x86_64..."
cmake ${OCCT_SRC_DIR} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DUSE_TK=OFF \
  -DUSE_FREETYPE=OFF \
  -DUSE_XLIB=OFF \
  -DUSE_OPENGL=OFF \
  -DUSE_GLES2=OFF \
  -DUSE_FREEIMAGE=OFF \
  -DUSE_RAPIDJSON=OFF \
  -DUSE_DRACO=OFF \
  -DBUILD_MODULE_Draw=OFF \
  -DBUILD_MODULE_Visualization=OFF \
  -DBUILD_MODULE_ApplicationFramework=OFF \
  -DBUILD_DOC_Overview=OFF \
  -DBUILD_LIBRARY_TYPE=Static \
  -DINSTALL_TEST_CASES=OFF \
  -DINSTALL_SAMPLES=OFF

echo "==> Building Open CASCADE (using ${NUM_CORES} cores)..."
cmake --build . --config Release --parallel ${NUM_CORES}

echo "==> Installing to ${INSTALL_DIR}..."
cmake --install .

echo "==> Build complete!"
echo "Installation directory: ${INSTALL_DIR}"
echo "Include directory: ${INSTALL_DIR}/include/opencascade"
echo "Library directory: ${INSTALL_DIR}/lib"
