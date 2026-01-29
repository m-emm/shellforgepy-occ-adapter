# PowerShell script to build Open CASCADE for Windows x64
# Compatible with GitHub Actions Windows runners and local Windows builds

$ErrorActionPreference = "Stop"

Write-Host "Starting Open CASCADE Windows build..."

# Configuration
$OCCT_VERSION = "OCCT-7.9"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$OCCT_SRC_DIR = Join-Path $SCRIPT_DIR "occt"
$BUILD_DIR = Join-Path $SCRIPT_DIR "build_windows"
$INSTALL_DIR = Join-Path $SCRIPT_DIR "install_windows"
$NUM_CORES = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors

Write-Host "Configuration:"
Write-Host "  Source: $OCCT_SRC_DIR"
Write-Host "  Build:  $BUILD_DIR"
Write-Host "  Install: $INSTALL_DIR"
Write-Host "  Cores: $NUM_CORES"

# Clean previous build
Write-Host "`n==> Cleaning previous build..."
if (Test-Path $BUILD_DIR) {
    Remove-Item -Recurse -Force $BUILD_DIR
}
if (Test-Path $INSTALL_DIR) {
    Remove-Item -Recurse -Force $INSTALL_DIR
}

# Clone source if not exists
if (-not (Test-Path $OCCT_SRC_DIR)) {
    Write-Host "`n==> Cloning Open CASCADE ${OCCT_VERSION}..."
    git clone --branch $OCCT_VERSION --depth 1 https://github.com/Open-Cascade-SAS/OCCT.git $OCCT_SRC_DIR
    if ($LASTEXITCODE -ne 0) {
        throw "Git clone failed"
    }
} else {
    Write-Host "`n==> Using existing source directory: $OCCT_SRC_DIR"
}

# Create build directory
Write-Host "`n==> Creating build directory..."
New-Item -ItemType Directory -Force -Path $BUILD_DIR | Out-Null
Set-Location $BUILD_DIR

# Detect Visual Studio and set generator
Write-Host "`n==> Detecting build environment..."
$generator = "Visual Studio 17 2022"  # VS 2022 (default on GitHub Actions)
$architecture = "x64"

# Try to find VS 2022, fallback to VS 2019, or use Ninja
if (Get-Command "vswhere.exe" -ErrorAction SilentlyContinue) {
    $vsPath = & vswhere.exe -latest -property installationPath
    if ($vsPath) {
        Write-Host "  Found Visual Studio at: $vsPath"
    }
}

# Check for Ninja (faster builds)
if (Get-Command "ninja" -ErrorAction SilentlyContinue) {
    Write-Host "  Ninja found, using Ninja generator for faster builds"
    $generator = "Ninja"
    $architecture = $null
}

Write-Host "  Generator: $generator"

# Configure CMake
Write-Host "`n==> Configuring headless build for Windows x64..."
$cmakeArgs = @(
    $OCCT_SRC_DIR,
    "-DCMAKE_BUILD_TYPE=Release",
    "-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR",
    "-DUSE_TK=OFF",
    "-DUSE_FREETYPE=OFF",
    "-DUSE_XLIB=OFF",
    "-DUSE_OPENGL=OFF",
    "-DUSE_GLES2=OFF",
    "-DUSE_FREEIMAGE=OFF",
    "-DUSE_RAPIDJSON=OFF",
    "-DUSE_DRACO=OFF",
    "-DBUILD_MODULE_Draw=OFF",
    "-DBUILD_MODULE_Visualization=OFF",
    "-DBUILD_MODULE_ApplicationFramework=OFF",
    "-DBUILD_DOC_Overview=OFF",
    "-DBUILD_LIBRARY_TYPE=Static",
    "-DINSTALL_TEST_CASES=OFF",
    "-DINSTALL_SAMPLES=OFF"
)

if ($generator -eq "Ninja") {
    $cmakeArgs += "-G", "Ninja"
} else {
    $cmakeArgs += "-G", $generator
    if ($architecture) {
        $cmakeArgs += "-A", $architecture
    }
}

Write-Host "Running: cmake $cmakeArgs"
& cmake @cmakeArgs
if ($LASTEXITCODE -ne 0) {
    throw "CMake configuration failed"
}

# Build
Write-Host "`n==> Building Open CASCADE (using $NUM_CORES cores)..."
& cmake --build . --config Release --parallel $NUM_CORES
if ($LASTEXITCODE -ne 0) {
    throw "Build failed"
}

# Install
Write-Host "`n==> Installing to $INSTALL_DIR..."
& cmake --install . --config Release
if ($LASTEXITCODE -ne 0) {
    throw "Installation failed"
}

# Summary
Write-Host "`n==> Build complete!"
Write-Host "Installation directory: $INSTALL_DIR"
Write-Host "Include directory: $(Join-Path $INSTALL_DIR 'include\opencascade')"
Write-Host "Library directory: $(Join-Path $INSTALL_DIR 'lib')"
Write-Host ""
Write-Host "Build artifacts:"
if (Test-Path (Join-Path $INSTALL_DIR "lib")) {
    $libCount = (Get-ChildItem (Join-Path $INSTALL_DIR "lib") -Filter "*.lib").Count
    Write-Host "  Libraries: $libCount .lib files"
}
if (Test-Path (Join-Path $INSTALL_DIR "include\opencascade")) {
    $headerCount = (Get-ChildItem (Join-Path $INSTALL_DIR "include\opencascade") -Filter "*.hxx").Count
    Write-Host "  Headers: $headerCount .hxx files"
}
