@echo off
chcp 65001 > nul
color 0A
echo.
echo ========================================
echo      BOK to ACCDB Converter
echo      محول ملفات BOK إلى ACCDB
echo ========================================
echo.
echo اختر النوع المطلوب:
echo Choose your preferred version:
echo.
echo [1] الواجهة الرسومية المحسنة - Enhanced GUI (الأفضل)
echo [2] سطر الأوامر المحسن - Enhanced Console  
echo [3] الواجهة الرسومية العادية - Basic GUI
echo [4] سطر الأوامر العادي - Basic Console
echo [5] عرض التعليمات - Show Instructions
echo [0] خروج - Exit
echo.
set /p choice="أدخل اختيارك Enter your choice (1-5): "

if "%choice%"=="1" (
    echo.
    echo تشغيل الواجهة الرسومية المحسنة...
    echo Starting Enhanced GUI...
    start "" "BokConverterGUI_Enhanced.exe"
    goto end
)

if "%choice%"=="2" (
    echo.
    echo تشغيل سطر الأوامر المحسن...
    echo Starting Enhanced Console...
    start "" "BokConverter_Enhanced.exe"
    goto end
)

if "%choice%"=="3" (
    echo.
    echo تشغيل الواجهة الرسومية العادية...
    echo Starting Basic GUI...
    start "" "BokConverterGUI.exe"
    goto end
)

if "%choice%"=="4" (
    echo.
    echo تشغيل سطر الأوامر العادي...
    echo Starting Basic Console...
    start "" "BokConverter.exe"
    goto end
)

if "%choice%"=="5" (
    echo.
    echo فتح التعليمات...
    echo Opening Instructions...
    start "" "notepad.exe" "حزمة_النقل_للصديق.txt"
    goto end
)

if "%choice%"=="0" (
    goto end
)

echo.
echo خيار غير صحيح! Invalid choice!
pause
goto start

:end
echo.
echo شكراً لاستخدام البرنامج
echo Thank you for using the program!
timeout /t 2 > nul
