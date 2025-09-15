@echo off
chcp 65001 > nul
echo ========================================
echo     BOK to ACCDB Converter - GUI
echo ========================================
echo.

cd /d "%~dp0"

echo Starting Graphical User Interface...
echo.

powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "BokConverterGUI_EN.ps1"
