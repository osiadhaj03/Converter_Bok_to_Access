@echo off
chcp 65001 > nul
echo ========================================
echo     برنامج تحويل ملفات .bok إلى .accdb
echo ========================================
echo.

cd /d "%~dp0"

if not exist "BokConverter.exe" (
    echo خطأ: لم يتم العثور على BokConverter.exe
    echo يرجى التأكد من وجود الملف التنفيذي في نفس المجلد
    pause
    exit /b 1
)

echo تشغيل البرنامج...
echo.
BokConverter.exe

pause
