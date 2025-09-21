# Enhanced BOK Converter - Complete Build and Installer Creation Script
# This script builds the executable and creates the installer in one step

Write-Host "=== Enhanced BOK Converter Complete Build Process ===" -ForegroundColor Green
Write-Host "Building executable and creating installer..." -ForegroundColor Yellow

# Define paths
$scriptDir = $PSScriptRoot
$rootDir = Split-Path $scriptDir -Parent
$buildScript = Join-Path $rootDir "build\build-executable.ps1"
$distDir = Join-Path $rootDir "dist"
$installerScript = Join-Path $rootDir "installer\setup-script.nsi"

Write-Host "Root directory: $rootDir" -ForegroundColor Cyan

# Step 1: Build the executable
Write-Host "`n--- Step 1: Building Executable ---" -ForegroundColor Magenta
if (Test-Path $buildScript) {
    try {
        & $buildScript
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERROR: Build script failed!" -ForegroundColor Red
            exit 1
        }
    }
    catch {
        Write-Host "ERROR: Failed to run build script: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "ERROR: Build script not found: $buildScript" -ForegroundColor Red
    exit 1
}

# Step 2: Verify executable was created
$exePath = Join-Path $distDir "BokConverterGUI_Enhanced.exe"
if (-Not (Test-Path $exePath)) {
    Write-Host "ERROR: Executable not found after build: $exePath" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Executable built successfully" -ForegroundColor Green

# Step 3: Create installer
Write-Host "`n--- Step 2: Creating Installer ---" -ForegroundColor Magenta

# Check if NSIS is installed
$nsisPath = $null
$commonPaths = @(
    "${env:ProgramFiles}\NSIS\makensis.exe",
    "${env:ProgramFiles(x86)}\NSIS\makensis.exe",
    "C:\Program Files\NSIS\makensis.exe",
    "C:\Program Files (x86)\NSIS\makensis.exe"
)

foreach ($path in $commonPaths) {
    if (Test-Path $path) {
        $nsisPath = $path
        break
    }
}

if (-not $nsisPath) {
    Write-Host "WARNING: NSIS not found - cannot create installer!" -ForegroundColor Yellow
    Write-Host "Install NSIS from: https://nsis.sourceforge.io/Download" -ForegroundColor Yellow
    Write-Host "Or install via chocolatey: choco install nsis" -ForegroundColor Yellow
    Write-Host "Executable is ready at: $exePath" -ForegroundColor Green
    exit 0
}

Write-Host "✓ NSIS found at: $nsisPath" -ForegroundColor Green

# Create license file if needed
$licenseFile = Join-Path $rootDir "docs\LICENSE.txt"
if (-Not (Test-Path $licenseFile)) {
    Write-Host "Creating license file..." -ForegroundColor Yellow
    $licenseContent = @"
MIT License

Copyright (c) 2024 BOK Converter Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
    Set-Content -Path $licenseFile -Value $licenseContent -Encoding UTF8
    Write-Host "✓ License file created" -ForegroundColor Green
}

# Build installer
$outputInstaller = Join-Path $distDir "BokConverter_Setup.exe"
Write-Host "Building installer..." -ForegroundColor Yellow

try {
    $process = Start-Process -FilePath $nsisPath -ArgumentList "`"$installerScript`"" -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0 -and (Test-Path $outputInstaller)) {
        Write-Host "✓ INSTALLER CREATED SUCCESSFULLY!" -ForegroundColor Green
        Write-Host "Installer location: $outputInstaller" -ForegroundColor Green
        
        $fileSize = (Get-Item $outputInstaller).Length
        $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
        Write-Host "Installer size: $fileSizeMB MB" -ForegroundColor Cyan
    } else {
        Write-Host "ERROR: Installer creation failed!" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "ERROR: Failed to create installer: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== BUILD PROCESS COMPLETE ===" -ForegroundColor Green
Write-Host "Ready for distribution:" -ForegroundColor Cyan
Write-Host "  • Executable: $exePath" -ForegroundColor White
Write-Host "  • Installer: $outputInstaller" -ForegroundColor White
Create-Installer