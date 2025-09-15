# BOK to ACCDB Converter - Portable Enhanced Version
# Universal PowerShell Script - Works from any location

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InputDir = Join-Path $ScriptDir "input"
$OutputDir = Join-Path $ScriptDir "output"

Write-Host "=== BOK to ACCDB Converter - Portable Edition ===" -ForegroundColor Green
Write-Host "Script Location: $ScriptDir" -ForegroundColor Cyan
Write-Host ""

# Create directories if they don't exist
if (!(Test-Path $InputDir)) {
    New-Item -ItemType Directory -Path $InputDir -Force | Out-Null
    Write-Host "Created input directory: $InputDir" -ForegroundColor Yellow
}

if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Write-Host "Created output directory: $OutputDir" -ForegroundColor Yellow
}

Write-Host "Input folder: $InputDir" -ForegroundColor Cyan
Write-Host "Output folder: $OutputDir" -ForegroundColor Cyan
Write-Host ""

# Check for BOK files
$bokFiles = Get-ChildItem -Path $InputDir -Filter "*.bok" -ErrorAction SilentlyContinue

if ($bokFiles.Count -eq 0) {
    Write-Host "No .bok files found in input folder!" -ForegroundColor Red
    Write-Host "Please copy your .bok files to: $InputDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Instructions:" -ForegroundColor White
    Write-Host "1. Copy your .bok files to the 'input' folder" -ForegroundColor White
    Write-Host "2. Run this script again" -ForegroundColor White
    Write-Host "3. Converted files will be saved in 'output' folder" -ForegroundColor White
    Read-Host "Press Enter to exit"
    return
}

Write-Host "Found $($bokFiles.Count) .bok files to convert" -ForegroundColor Green
Write-Host ""

# Counters
$filesConverted = 0
$filesSkipped = 0
$filesError = 0

try {
    Write-Host "Starting Microsoft Access..." -ForegroundColor Yellow
    
    # Create Access object
    $accessApp = New-Object -ComObject Access.Application
    $accessApp.Visible = $false
    $accessApp.AutomationSecurity = 1  # msoAutomationSecurityLow
    
    # Convert each file
    foreach ($bokFile in $bokFiles) {
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($bokFile.Name)
        $tempMdbPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "$fileName.mdb")
        $outputAccdbPath = Join-Path $OutputDir "$fileName.accdb"
        
        Write-Host "Converting: $($bokFile.Name)... " -NoNewline
        
        try {
            # Check if converted file already exists
            if (Test-Path $outputAccdbPath) {
                Write-Host "Already exists - Skipped" -ForegroundColor Yellow
                $filesSkipped++
                continue
            }
            
            # Copy .bok to temp as .mdb
            Copy-Item $bokFile.FullName $tempMdbPath -Force
            
            # Enhanced conversion with multiple methods
            $conversionSuccess = $false
            
            # Method 1: Enhanced TransferDatabase method
            try {
                $accessApp.OpenCurrentDatabase($tempMdbPath, $false)
                
                # Create new ACCDB database
                $accessApp.NewCurrentDatabase($outputAccdbPath, [Microsoft.Office.Interop.Access.AcNewDatabaseFormat]::acNewDatabaseFormatAccess2007)
                $accessApp.CloseCurrentDatabase()
                
                # Reopen source database
                $accessApp.OpenCurrentDatabase($tempMdbPath, $false)
                
                # Transfer all objects
                $transferCount = 0
                
                # Transfer tables (excluding system tables)
                try {
                    $tables = $accessApp.CurrentData.AllTables
                    foreach ($table in $tables) {
                        if (-not $table.Name.StartsWith("MSys")) {
                            try {
                                $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 0, $table.Name, $table.Name, $false)
                                $transferCount++
                            }
                            catch { }
                        }
                    }
                } catch { }
                
                # Transfer queries
                try {
                    $queries = $accessApp.CurrentData.AllQueries
                    foreach ($query in $queries) {
                        try {
                            $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 1, $query.Name, $query.Name, $false)
                            $transferCount++
                        }
                        catch { }
                    }
                } catch { }
                
                # Transfer forms
                try {
                    $forms = $accessApp.CurrentProject.AllForms
                    foreach ($form in $forms) {
                        try {
                            $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 2, $form.Name, $form.Name, $false)
                            $transferCount++
                        }
                        catch { }
                    }
                } catch { }
                
                # Transfer reports
                try {
                    $reports = $accessApp.CurrentProject.AllReports
                    foreach ($report in $reports) {
                        try {
                            $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 3, $report.Name, $report.Name, $false)
                            $transferCount++
                        }
                        catch { }
                    }
                } catch { }
                
                $accessApp.CloseCurrentDatabase()
                
                if ($transferCount -gt 0) {
                    $conversionSuccess = $true
                }
            }
            catch { }
            
            # Method 2: ConvertAccessProject (if Method 1 failed)
            if (-not $conversionSuccess) {
                try {
                    $accessApp.CloseCurrentDatabase()
                    $accessApp.ConvertAccessProject($tempMdbPath, $outputAccdbPath, 12) # acFileFormatAccess2007
                    $conversionSuccess = $true
                }
                catch { }
            }
            
            # Method 3: CompactRepair (as last resort)
            if (-not $conversionSuccess) {
                try {
                    $accessApp.CloseCurrentDatabase()
                    $accessApp.CompactRepair($tempMdbPath, $outputAccdbPath, $false)
                    $conversionSuccess = $true
                }
                catch { }
            }
            
            # Clean up temp file
            if (Test-Path $tempMdbPath) {
                Remove-Item $tempMdbPath -Force
            }
            
            if ($conversionSuccess) {
                Write-Host "Success" -ForegroundColor Green
                $filesConverted++
            } else {
                Write-Host "Failed" -ForegroundColor Red
                $filesError++
            }
        }
        catch {
            Write-Host "Failed" -ForegroundColor Red
            Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
            $filesError++
            
            # Clean up temp files
            try {
                $accessApp.CloseCurrentDatabase()
                if (Test-Path $tempMdbPath) {
                    Remove-Item $tempMdbPath -Force
                }
            }
            catch { }
        }
    }
}
catch {
    Write-Host ""
    Write-Host "General error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure Microsoft Access is installed on the system." -ForegroundColor Yellow
}
finally {
    # Close Access and free memory
    if ($accessApp) {
        try {
            $accessApp.Quit()
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($accessApp) | Out-Null
        }
        catch { }
    }
}

# Display final results
Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Green
Write-Host "Operation Report:" -ForegroundColor Green
Write-Host "- Successfully converted: $filesConverted files" -ForegroundColor Green
Write-Host "- Skipped (already exists): $filesSkipped files" -ForegroundColor Yellow
Write-Host "- Failed to convert: $filesError files" -ForegroundColor Red
Write-Host "- Total files: $($filesConverted + $filesSkipped + $filesError) files" -ForegroundColor Cyan
Write-Host ""

if ($filesConverted -gt 0) {
    Write-Host "Converted files saved in: $OutputDir" -ForegroundColor Green
    Write-Host ""
    
    $openFolder = Read-Host "Open output folder? (y/n)"
    if ($openFolder -eq 'y' -or $openFolder -eq 'Y') {
        Start-Process "explorer.exe" $OutputDir
    }
}

Write-Host ""
Write-Host "Script completed! Press Enter to exit..." -ForegroundColor Cyan
Read-Host
