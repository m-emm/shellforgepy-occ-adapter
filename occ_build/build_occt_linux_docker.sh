#!/bin/bash
# Build Open CASCADE for Linux x86_64 using Docker

set -euo pipefail
trap 'echo "Script $0 failed at line $LINENO" >&2' ERR

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPT_FULLPATH="$(realpath "$0")"

echo "Running ${SCRIPT_FULLPATH} with args: $@"

# Configuration
DOCKER_IMAGE="ubuntu:22.04"
CONTAINER_NAME="occt-builder-$$"

# Ensure source is cloned on host (will be mounted into container)
OCCT_VERSION="OCCT-7.9"
OCCT_SRC_DIR="${SCRIPT_DIR}/occt"

if [ ! -d "${OCCT_SRC_DIR}" ]; then
    echo "==> Cloning Open CASCADE ${OCCT_VERSION} on host..."
    git clone --branch ${OCCT_VERSION} --depth 1 https://github.com/Open-Cascade-SAS/OCCT.git ${OCCT_SRC_DIR}
else
    echo "==> Using existing source directory: ${OCCT_SRC_DIR}"
fi

echo "==> Starting Docker container for build..."
echo "    Image: ${DOCKER_IMAGE}"
echo "    Mounting: ${SCRIPT_DIR}"

# Run the build inside Docker with mounted volumes
docker run --rm \
  --name ${CONTAINER_NAME} \
  -v "${SCRIPT_DIR}:/workspace" \
  -w /workspace \
  ${DOCKER_IMAGE} \
  bash -c "
    set -euo pipefail
    
    echo '==> Installing build dependencies...'
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
      build-essential \
      cmake \
      git \
      ninja-build \
      > /dev/null
    
    echo '==> Running build script...'
    chmod +x /workspace/build_occt_linux_x86.sh
    /workspace/build_occt_linux_x86.sh
    
    echo '==> Setting permissions on build output...'
    # Make sure the output is accessible by the host user
    chmod -R a+rw /workspace/build_linux /workspace/install_linux 2>/dev/null || true
  "

echo ""
echo "==> Docker build complete!"
echo "Build directory: ${SCRIPT_DIR}/build_linux"
echo "Installation directory: ${SCRIPT_DIR}/install_linux"
echo "Include directory: ${SCRIPT_DIR}/install_linux/include/opencascade"
echo "Library directory: ${SCRIPT_DIR}/install_linux/lib"
