@echo off
echo Starting BOK to ACCDB Converter...
echo Please wait...

cd /d "%~dp0"

if exist "executables\BokConverterGUI_Enhanced.exe" (
    start "" "executables\BokConverterGUI_Enhanced.exe"
) else (
    echo Error: GUI executable not found!
    echo Please ensure BokConverterGUI_Enhanced.exe exists in executables folder.
    pause
)
