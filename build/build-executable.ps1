# Enhanced BOK Converter - Build Script
# PowerShell script to build the executable from the PowerShell script

Write-Host "=== Enhanced BOK Converter Build Script ===" -ForegroundColor Green
Write-Host "Building executable from PowerShell script..." -ForegroundColor Yellow

# Define paths
$buildDir = $PSScriptRoot
$rootDir = Split-Path $buildDir -Parent
$scriptPath = Join-Path $rootDir "src\BokConverterGUI_Enhanced.ps1"
$outputPath = Join-Path $rootDir "dist\BokConverterGUI_Enhanced.exe"
$iconPath = Join-Path $rootDir "src\icon.ico"
$manifestPath = Join-Path $rootDir "src\manifest.xml"

Write-Host "Source script: $scriptPath" -ForegroundColor Cyan
Write-Host "Output executable: $outputPath" -ForegroundColor Cyan

# Check if required files exist
if (-Not (Test-Path $scriptPath)) {
    Write-Host "ERROR: PowerShell script not found: $scriptPath" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Source script found" -ForegroundColor Green

# Create dist directory if it doesn't exist
$distDir = Split-Path $outputPath -Parent
if (-Not (Test-Path $distDir)) {
    New-Item -ItemType Directory -Path $distDir -Force | Out-Null
    Write-Host "✓ Created dist directory" -ForegroundColor Green
}

# Install PS2EXE if not available
if (-Not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "Installing PS2EXE module..." -ForegroundColor Yellow
    try {
        Install-Module -Name ps2exe -Force -Scope CurrentUser
        Write-Host "✓ PS2EXE module installed" -ForegroundColor Green
    }
    catch {
        Write-Host "ERROR: Failed to install PS2EXE module: $_" -ForegroundColor Red
        Write-Host "Please install manually: Install-Module -Name ps2exe" -ForegroundColor Yellow
        exit 1
    }
}

# Import PS2EXE module
Import-Module ps2exe

# Build parameters
$ps2exeParams = @{
    inputFile = $scriptPath
    outputFile = $outputPath
    noConsole = $true
    title = "Enhanced BOK Converter"
    description = "BOK to ACCDB File Converter"
    company = "Osaid Haj & Aziz Hashlamoun"
    product = "Enhanced BOK Converter"
    version = "1.0.0.0"
}

# Add icon if available
if (Test-Path $iconPath) {
    $ps2exeParams.iconFile = $iconPath
    Write-Host "✓ Icon file found and will be included" -ForegroundColor Green
} else {
    Write-Host "⚠ Icon file not found, building without icon" -ForegroundColor Yellow
}

# Execute the conversion
Write-Host "Converting PowerShell script to executable..." -ForegroundColor Yellow
try {
    ps2exe @ps2exeParams
    
    if (Test-Path $outputPath) {
        Write-Host "✓ BUILD SUCCESSFUL!" -ForegroundColor Green
        Write-Host "Executable created: $outputPath" -ForegroundColor Green
        
        # Get file size
        $fileSize = (Get-Item $outputPath).Length
        $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
        Write-Host "File size: $fileSizeMB MB" -ForegroundColor Cyan
    } else {
        Write-Host "ERROR: Build completed but executable not found!" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "ERROR: Build failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "=== Build Process Complete ===" -ForegroundColor Green

if ($LASTEXITCODE -eq 0) {
    Write-Host "Executable created successfully: $outputPath"
} else {
    Write-Host "Failed to create executable."
    exit 1
}