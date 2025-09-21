# Enhanced BOK Converter - Simple Build Script
Write-Host "=== Building Enhanced BOK Converter ===" -ForegroundColor Green

# Define paths
$scriptDir = $PSScriptRoot
$rootDir = Split-Path $scriptDir -Parent
$distDir = Join-Path $rootDir "dist"

# Create dist directory if it doesn't exist
if (-Not (Test-Path $distDir)) {
    New-Item -ItemType Directory -Path $distDir -Force | Out-Null
    Write-Host "Created dist directory" -ForegroundColor Green
}

# Try to build executable
Write-Host "Building executable..." -ForegroundColor Yellow
try {
    # Install PS2EXE if not available
    if (-Not (Get-Module -ListAvailable -Name ps2exe)) {
        Write-Host "Installing PS2EXE module..." -ForegroundColor Yellow
        Install-Module -Name ps2exe -Force -Scope CurrentUser -ErrorAction Stop
        Write-Host "PS2EXE module installed" -ForegroundColor Green
    }
    
    # Import module
    Import-Module ps2exe -ErrorAction Stop
    
    # Convert script to executable
    $inputScript = Join-Path $rootDir "src\BokConverterGUI_Enhanced.ps1"
    $outputExe = Join-Path $distDir "BokConverterGUI_Enhanced.exe"
    
    if (Test-Path $inputScript) {
        ps2exe -inputFile $inputScript -outputFile $outputExe -noConsole -title "Enhanced BOK Converter" -description "BOK to ACCDB File Converter"
        
        if (Test-Path $outputExe) {
            Write-Host "SUCCESS: Executable created!" -ForegroundColor Green
            Write-Host "Location: $outputExe" -ForegroundColor Cyan
            
            $fileSize = (Get-Item $outputExe).Length
            $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
            Write-Host "File size: $fileSizeMB MB" -ForegroundColor Cyan
        } else {
            Write-Host "ERROR: Failed to create executable" -ForegroundColor Red
        }
    } else {
        Write-Host "ERROR: Source script not found: $inputScript" -ForegroundColor Red
    }
}
catch {
    Write-Host "ERROR: Build failed - $_" -ForegroundColor Red
}

Write-Host "=== Build Complete ===" -ForegroundColor Green