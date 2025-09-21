@echo off
REM Compile the Inno Setup script to create the installer executable

REM Set the path to the Inno Setup compiler
set ISCC_PATH="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"

REM Set the path to the setup configuration file
set SETUP_CONFIG="setup-config.iss"

REM Check if Inno Setup compiler exists
if not exist %ISCC_PATH% (
    echo Inno Setup compiler not found at %ISCC_PATH%.
    exit /b 1
)

REM Compile the setup configuration
%ISCC_PATH% %SETUP_CONFIG%

REM Check for successful compilation
if %errorlevel% neq 0 (
    echo Compilation failed.
    exit /b 1
)

echo Compilation successful. Installer created.