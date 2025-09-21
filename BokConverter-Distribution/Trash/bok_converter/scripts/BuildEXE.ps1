# Build Script for Creating EXE from PowerShell
# This script creates a standalone executable from PowerShell script

Write-Host "=== BOK to ACCDB Converter - EXE Builder ===" -ForegroundColor Green
Write-Host ""

# Check if ps2exe is available
try {
    $ps2exeAvailable = Get-Command "ps2exe" -ErrorAction SilentlyContinue
    if (-not $ps2exeAvailable) {
        Write-Host "Installing ps2exe module..." -ForegroundColor Yellow
        Install-Module -Name ps2exe -Force -Scope CurrentUser
        Import-Module ps2exe
    }
}
catch {
    Write-Host "Installing ps2exe module..." -ForegroundColor Yellow
    Install-Module -Name ps2exe -Force -Scope CurrentUser -AllowClobber
    Import-Module ps2exe
}

# Create standalone EXE files
Write-Host "Creating EXE files..." -ForegroundColor Cyan

# Convert Enhanced Console Version
Write-Host "Building: BokConverter_Enhanced.exe" -ForegroundColor White
ps2exe -inputFile "BokConverter_Enhanced.ps1" -outputFile "BokConverter_Enhanced.exe" -title "Enhanced BOK to ACCDB Converter" -description "Professional BOK to ACCDB Database Converter" -company "BOK Converter Team" -version "2.0.0.0" -copyright "2025" -iconFile $null -noConsole:$false -noOutput:$false -noError:$false -requireAdmin:$false

# Convert Enhanced GUI Version  
Write-Host "Building: BokConverterGUI_Enhanced.exe" -ForegroundColor White
ps2exe -inputFile "BokConverterGUI_Enhanced.ps1" -outputFile "BokConverterGUI_Enhanced.exe" -title "Enhanced BOK to ACCDB Converter GUI" -description "Professional BOK to ACCDB Database Converter with GUI" -company "BOK Converter Team" -version "2.0.0.0" -copyright "2025" -iconFile $null -noConsole:$true -noOutput:$false -noError:$false -requireAdmin:$false

# Convert Regular Console Version
Write-Host "Building: BokConverter.exe" -ForegroundColor White
ps2exe -inputFile "BokConverter.ps1" -outputFile "BokConverter.exe" -title "BOK to ACCDB Converter" -description "BOK to ACCDB Database Converter" -company "BOK Converter Team" -version "1.0.0.0" -copyright "2025" -iconFile $null -noConsole:$false -noOutput:$false -noError:$false -requireAdmin:$false

# Convert Regular GUI Version
Write-Host "Building: BokConverterGUI.exe" -ForegroundColor White
ps2exe -inputFile "BokConverterGUI_EN.ps1" -outputFile "BokConverterGUI.exe" -title "BOK to ACCDB Converter GUI" -description "BOK to ACCDB Database Converter with GUI" -company "BOK Converter Team" -version "1.0.0.0" -copyright "2025" -iconFile $null -noConsole:$true -noOutput:$false -noError:$false -requireAdmin:$false

Write-Host ""
Write-Host "Build completed!" -ForegroundColor Green
Write-Host "Created EXE files:" -ForegroundColor Cyan
Write-Host "- BokConverter_Enhanced.exe (Recommended Console)" -ForegroundColor Yellow
Write-Host "- BokConverterGUI_Enhanced.exe (Recommended GUI)" -ForegroundColor Yellow  
Write-Host "- BokConverter.exe (Basic Console)" -ForegroundColor White
Write-Host "- BokConverterGUI.exe (Basic GUI)" -ForegroundColor White

Read-Host "Press Enter to exit"
