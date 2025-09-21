@echo off
chcp 65001 > nul
echo ========================================
echo     برنامج تحويل ملفات .bok إلى .accdb
echo ========================================
echo.

cd /d "%~dp0"

echo تشغيل البرنامج...
echo.

powershell.exe -ExecutionPolicy Bypass -File "BokConverter.ps1"

pause
