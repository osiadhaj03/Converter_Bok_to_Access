# BOK to ACCDB Converter
# PowerShell Script Version

Write-Host "=== BOK to ACCDB Converter ===" -ForegroundColor Green
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
            
            # Copy .bok to temp folder as .mdb
            Copy-Item $bokFile.FullName $tempMdbPath -Force
            
            # Use CompactRepair to convert to .accdb format
            # This method doesn't require opening the database first
            $accessApp.CompactRepair($tempMdbPath, $outputAccdbPath, $false)
            
            # Delete temp file
            if (Test-Path $tempMdbPath) {
                Remove-Item $tempMdbPath -Force
            }
            
            Write-Host "Success" -ForegroundColor Green
            $filesConverted++
        }
        catch {
            Write-Host "Failed" -ForegroundColor Red
            Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
            $filesError++
            
            # Clean up temp files
            try {
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