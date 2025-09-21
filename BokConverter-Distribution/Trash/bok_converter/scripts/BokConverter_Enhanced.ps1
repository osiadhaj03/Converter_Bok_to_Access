# BOK to ACCDB Converter - Enhanced Version
# Uses proper Access conversion methods

Write-Host "=== Enhanced BOK to ACCDB Converter ===" -ForegroundColor Green
Write-Host ""

# Folder paths
$bokFolderPath = "d:\test5\bok file"
$outputFolderPath = "d:\test5\access file"

# Check if folders exist
if (!(Test-Path $bokFolderPath)) {
    Write-Host "Error: Source folder not found: $bokFolderPath" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

if (!(Test-Path $outputFolderPath)) {
    Write-Host "Creating output folder: $outputFolderPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $outputFolderPath -Force | Out-Null
}

Write-Host "Source folder: $bokFolderPath" -ForegroundColor Cyan
Write-Host "Output folder: $outputFolderPath" -ForegroundColor Cyan
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
    
    # Get .bok files
    $bokFiles = Get-ChildItem -Path $bokFolderPath -Filter "*.bok"
    
    if ($bokFiles.Count -eq 0) {
        Write-Host "No .bok files found in the folder." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        return
    }
    
    Write-Host "Found $($bokFiles.Count) files to convert" -ForegroundColor Green
    Write-Host ""
    
    # Convert each file
    foreach ($bokFile in $bokFiles) {
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($bokFile.Name)
        $tempMdbPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "$fileName.mdb")
        $outputAccdbPath = Join-Path $outputFolderPath "$fileName.accdb"
        
        Write-Host "Converting: $($bokFile.Name)... " -NoNewline
        
        try {
            # Check if converted file already exists
            if (Test-Path $outputAccdbPath) {
                Write-Host "Already exists - Skipped" -ForegroundColor Yellow
                $filesSkipped++
                continue
            }
            
            # Step 1: Copy .bok to temp folder as .mdb
            Copy-Item $bokFile.FullName $tempMdbPath -Force
            
            # Step 2: Open the MDB database and convert properly
            $accessApp.OpenCurrentDatabase($tempMdbPath, $false)
            
            # Method 1: Try TransferDatabase method (most reliable)
            try {
                # Create new ACCDB database with correct enum
                $accessApp.NewCurrentDatabase($outputAccdbPath, [Microsoft.Office.Interop.Access.AcNewDatabaseFormat]::acNewDatabaseFormatAccess2007)
                $accessApp.CloseCurrentDatabase()
                
                # Reopen source database
                $accessApp.OpenCurrentDatabase($tempMdbPath, $false)
                
                # Get all tables (excluding system tables)
                $tables = $accessApp.CurrentData.AllTables
                foreach ($table in $tables) {
                    if (-not $table.Name.StartsWith("MSys")) {
                        try {
                            $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 0, $table.Name, $table.Name, $false) # acExport, acTable
                        }
                        catch {
                            Write-Host "   Warning: Could not transfer table $($table.Name)" -ForegroundColor Yellow
                        }
                    }
                }
                
                # Get all queries
                $queries = $accessApp.CurrentData.AllQueries
                foreach ($query in $queries) {
                    try {
                        $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 1, $query.Name, $query.Name, $false) # acExport, acQuery
                    }
                    catch {
                        Write-Host "   Warning: Could not transfer query $($query.Name)" -ForegroundColor Yellow
                    }
                }
                
                # Get all forms
                $forms = $accessApp.CurrentProject.AllForms
                foreach ($form in $forms) {
                    try {
                        $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 2, $form.Name, $form.Name, $false) # acExport, acForm
                    }
                    catch {
                        Write-Host "   Warning: Could not transfer form $($form.Name)" -ForegroundColor Yellow
                    }
                }
                
                # Get all reports
                $reports = $accessApp.CurrentProject.AllReports
                foreach ($report in $reports) {
                    try {
                        $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 3, $report.Name, $report.Name, $false) # acExport, acReport
                    }
                    catch {
                        Write-Host "   Warning: Could not transfer report $($report.Name)" -ForegroundColor Yellow
                    }
                }
                
                $accessApp.CloseCurrentDatabase()
                $success = $true
            }
            catch {
                Write-Host "   Method 1 failed: $($_.Exception.Message)" -ForegroundColor Yellow
                
                # Method 2: Try ConvertAccessProject
                try {
                    $accessApp.CloseCurrentDatabase()
                    $accessApp.ConvertAccessProject($tempMdbPath, $outputAccdbPath, 12) # acFileFormatAccess2007
                    $success = $true
                }
                catch {
                    Write-Host "   Method 2 failed: $($_.Exception.Message)" -ForegroundColor Yellow
                    
                    # Method 3: Try CompactRepair as last resort
                    try {
                        $accessApp.CloseCurrentDatabase()
                        $accessApp.CompactRepair($tempMdbPath, $outputAccdbPath, $false)
                        $success = $true
                    }
                    catch {
                        Write-Host "   All methods failed" -ForegroundColor Red
                        $success = $false
                    }
                }
            }
            
            # Close current database if still open
            try {
                $accessApp.CloseCurrentDatabase()
            }
            catch { }
            
            # Clean up temp file
            if (Test-Path $tempMdbPath) {
                Remove-Item $tempMdbPath -Force
            }
            
            if ($success) {
                Write-Host "Success" -ForegroundColor Green
                $filesConverted++
            } else {
                Write-Host "Failed - Unknown error" -ForegroundColor Red
                $filesError++
            }
        }
        catch {
            Write-Host "Failed" -ForegroundColor Red
            Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
            $filesError++
            
            # Clean up temp files and close database
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
Write-Host ("=" * 50) -ForegroundColor Green
Write-Host "Operation Report:" -ForegroundColor Green
Write-Host "- Successfully converted: $filesConverted files" -ForegroundColor Green
Write-Host "- Skipped (already exists): $filesSkipped files" -ForegroundColor Yellow
Write-Host "- Failed to convert: $filesError files" -ForegroundColor Red
Write-Host "- Total files: $($filesConverted + $filesSkipped + $filesError) files" -ForegroundColor Cyan
Write-Host ""

if ($filesConverted -gt 0) {
    Write-Host "Converted files saved in: $outputFolderPath" -ForegroundColor Green
}

Read-Host "Press Enter to exit"
