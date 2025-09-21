# Enhanced BOK Converter - Automatic Requirements Installer
# تثبيت تلقائي للمتطلبات

Write-Host "=== Enhanced BOK Converter - Requirements Installer ===" -ForegroundColor Green
Write-Host "تثبيت المتطلبات اللازمة لتشغيل البرنامج..." -ForegroundColor Yellow
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "⚠ تشغيل كمستخدم عادي - بعض المتطلبات قد تحتاج صلاحيات إدارية" -ForegroundColor Yellow
    Write-Host "⚠ Running as user - some requirements may need admin rights" -ForegroundColor Yellow
    Write-Host ""
}

# Function to download file
function Download-File {
    param($url, $output)
    try {
        Write-Host "تحميل: $output..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        Write-Host "✓ تم التحميل بنجاح" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "✗ فشل التحميل: $_" -ForegroundColor Red
        return $false
    }
}

# 1. Set PowerShell Execution Policy
Write-Host "--- إعداد PowerShell Execution Policy ---" -ForegroundColor Magenta
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "✓ تم تحديث سياسة PowerShell" -ForegroundColor Green
}
catch {
    Write-Host "⚠ لم يتم تحديث سياسة PowerShell: $_" -ForegroundColor Yellow
}
Write-Host ""

# 2. Check .NET Framework
Write-Host "--- فحص .NET Framework ---" -ForegroundColor Magenta
$netVersion = Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" -Name Release -ErrorAction SilentlyContinue
if ($netVersion -and $netVersion.Release -ge 461808) {
    Write-Host "✓ .NET Framework 4.7.2+ موجود" -ForegroundColor Green
} else {
    Write-Host "⚠ .NET Framework غير موجود أو إصدار قديم" -ForegroundColor Yellow
    Write-Host "سيتم فتح صفحة التحميل..." -ForegroundColor Cyan
    Start-Process "https://dotnet.microsoft.com/download/dotnet-framework/net48"
}
Write-Host ""

# 3. Check Access Database Engine
Write-Host "--- فحص Access Database Engine ---" -ForegroundColor Magenta
$accessEngine = Get-ItemProperty "HKLM:SOFTWARE\Microsoft\Office\*\Access Connectivity Engine" -ErrorAction SilentlyContinue
if ($accessEngine) {
    Write-Host "✓ Access Database Engine موجود" -ForegroundColor Green
} else {
    Write-Host "⚠ Access Database Engine غير موجود" -ForegroundColor Yellow
    Write-Host "مطلوب للتعامل مع ملفات .accdb" -ForegroundColor Yellow
    
    $downloadChoice = Read-Host "هل تريد تحميل Access Database Engine؟ (y/n)"
    if ($downloadChoice -eq 'y' -or $downloadChoice -eq 'Y') {
        Write-Host "سيتم فتح صفحة التحميل..." -ForegroundColor Cyan
        Start-Process "https://www.microsoft.com/en-us/download/details.aspx?id=54920"
    }
}
Write-Host ""

# 4. Check Visual C++ Redistributable
Write-Host "--- فحص Visual C++ Redistributable ---" -ForegroundColor Magenta
$vcRedist = Get-ItemProperty "HKLM:SOFTWARE\Microsoft\VisualStudio\*\VC\Runtimes\x64" -ErrorAction SilentlyContinue
if ($vcRedist) {
    Write-Host "✓ Visual C++ Redistributable موجود" -ForegroundColor Green
} else {
    Write-Host "⚠ Visual C++ Redistributable قد يكون مطلوب" -ForegroundColor Yellow
    
    $downloadChoice = Read-Host "هل تريد تحميل Visual C++ Redistributable؟ (y/n)"
    if ($downloadChoice -eq 'y' -or $downloadChoice -eq 'Y') {
        Write-Host "سيتم فتح صفحة التحميل..." -ForegroundColor Cyan
        Start-Process "https://aka.ms/vs/17/release/vc_redist.x64.exe"
    }
}
Write-Host ""

# 5. Test the executable
Write-Host "--- اختبار البرنامج ---" -ForegroundColor Magenta
$exePath = Join-Path $PSScriptRoot "BokConverterGUI_Enhanced.exe"
if (Test-Path $exePath) {
    Write-Host "✓ البرنامج موجود: $exePath" -ForegroundColor Green
    
    $testChoice = Read-Host "هل تريد تشغيل البرنامج للاختبار؟ (y/n)"
    if ($testChoice -eq 'y' -or $testChoice -eq 'Y') {
        Write-Host "تشغيل البرنامج..." -ForegroundColor Cyan
        Start-Process $exePath
    }
} else {
    Write-Host "✗ البرنامج غير موجود في: $exePath" -ForegroundColor Red
}
Write-Host ""

Write-Host "=== انتهاء فحص المتطلبات ===" -ForegroundColor Green
Write-Host "البرنامج جاهز للاستخدام!" -ForegroundColor Cyan
Write-Host "Program is ready to use!" -ForegroundColor Cyan

Read-Host "اضغط Enter للإنهاء..."