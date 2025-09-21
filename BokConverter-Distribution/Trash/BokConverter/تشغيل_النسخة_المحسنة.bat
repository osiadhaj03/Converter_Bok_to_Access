@echo off
chcp 65001 > nul
echo ========================================
echo     Enhanced BOK to ACCDB Converter
echo     محول ملفات BOK المحسن
echo ========================================
echo.

cd /d "%~dp0"

echo تشغيل النسخة المحسنة من البرنامج...
echo Running Enhanced Version...
echo.

powershell.exe -ExecutionPolicy Bypass -File "BokConverter_Enhanced.ps1"

pause
