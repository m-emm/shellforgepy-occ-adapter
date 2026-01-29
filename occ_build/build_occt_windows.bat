@echo off
REM Batch script wrapper for PowerShell build script
REM Usage: build_occt_windows.bat

echo Starting Open CASCADE Windows build...
echo.

REM Check if PowerShell is available
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell is not available
    echo Please install PowerShell or run build_occt_windows.ps1 directly
    exit /b 1
)

REM Get script directory
set SCRIPT_DIR=%~dp0

REM Run PowerShell script with execution policy bypass
powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%build_occt_windows.ps1"

REM Check result
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Build failed with exit code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)

echo.
echo Build completed successfully!
exit /b 0
