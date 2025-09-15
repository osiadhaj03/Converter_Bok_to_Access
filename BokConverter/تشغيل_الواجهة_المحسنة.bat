@echo off
chcp 65001 > nul
echo ========================================
echo     Enhanced BOK to ACCDB Converter - GUI
echo     الواجهة الرسومية المحسنة
echo ========================================
echo.

cd /d "%~dp0"

echo تشغيل الواجهة الرسومية المحسنة...
echo Starting Enhanced GUI Version...
echo.

powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "BokConverterGUI_Enhanced.ps1"
