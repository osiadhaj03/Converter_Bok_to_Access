@echo off
echo ===================================================
echo    Enhanced BOK Converter - Quick Setup
echo ===================================================
echo.

echo تحضير النظام لتشغيل البرنامج...
echo Preparing system for BOK Converter...
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo ✓ Running as Administrator
) else (
    echo ⚠ Running as User - some features may need admin rights
)
echo.

REM Set PowerShell Execution Policy
echo Setting PowerShell Execution Policy...
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force" >nul 2>&1
if %errorLevel% == 0 (
    echo ✓ PowerShell policy updated
) else (
    echo ⚠ Could not update PowerShell policy
)
echo.

REM Check .NET Framework
echo Checking .NET Framework...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Release >nul 2>&1
if %errorLevel% == 0 (
    echo ✓ .NET Framework found
) else (
    echo ⚠ .NET Framework may need to be installed
    echo    Download from: https://dotnet.microsoft.com/download/dotnet-framework
)
echo.

REM Check for Access Database Engine
echo Checking Access Database Engine...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\REGISTRY\MACHINE\Software\Microsoft\Office" >nul 2>&1
if %errorLevel% == 0 (
    echo ✓ Microsoft Office/Access components found
) else (
    echo ⚠ Access Database Engine recommended for .accdb files
    echo    Download from: https://www.microsoft.com/en-us/download/details.aspx?id=54920
)
echo.

echo ===================================================
echo Setup completed! البرنامج جاهز للاستخدام
echo.
echo To run the program: انقر مرتين على BokConverterGUI_Enhanced.exe
echo ===================================================
echo.
pause