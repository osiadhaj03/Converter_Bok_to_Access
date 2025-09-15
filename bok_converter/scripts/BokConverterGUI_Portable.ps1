# BOK to ACCDB Converter - Portable GUI Version
# Universal PowerShell GUI Script - Works from any location

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BaseDir = Split-Path -Parent $ScriptDir
$InputDir = Join-Path $BaseDir "input"
$OutputDir = Join-Path $BaseDir "output"

# Create directories if they don't exist
if (!(Test-Path $InputDir)) {
    New-Item -ItemType Directory -Path $InputDir -Force | Out-Null
}
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "BOK to ACCDB Converter - Portable Edition"
$form.Size = New-Object System.Drawing.Size(850, 750)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::WhiteSmoke

# Title Label
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "BOK to ACCDB Converter - Portable Edition"
$lblTitle.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = [System.Drawing.Color]::DarkBlue
$lblTitle.Location = New-Object System.Drawing.Point(20, 20)
$lblTitle.Size = New-Object System.Drawing.Size(500, 30)
$form.Controls.Add($lblTitle)

# Subtitle Label
$lblSubtitle = New-Object System.Windows.Forms.Label
$lblSubtitle.Text = "Professional database conversion - Works anywhere!"
$lblSubtitle.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Italic)
$lblSubtitle.ForeColor = [System.Drawing.Color]::Gray
$lblSubtitle.Location = New-Object System.Drawing.Point(20, 50)
$lblSubtitle.Size = New-Object System.Drawing.Size(400, 20)
$form.Controls.Add($lblSubtitle)

# Current Folders Info
$lblCurrentFolders = New-Object System.Windows.Forms.Label
$lblCurrentFolders.Text = "Current Folders:"
$lblCurrentFolders.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblCurrentFolders.Location = New-Object System.Drawing.Point(20, 80)
$lblCurrentFolders.Size = New-Object System.Drawing.Size(120, 20)
$form.Controls.Add($lblCurrentFolders)

$lblInputFolder = New-Object System.Windows.Forms.Label
$lblInputFolder.Text = "Input: $InputDir"
$lblInputFolder.Font = New-Object System.Drawing.Font("Arial", 9)
$lblInputFolder.ForeColor = [System.Drawing.Color]::DarkGreen
$lblInputFolder.Location = New-Object System.Drawing.Point(20, 100)
$lblInputFolder.Size = New-Object System.Drawing.Size(800, 20)
$form.Controls.Add($lblInputFolder)

$lblOutputFolder = New-Object System.Windows.Forms.Label
$lblOutputFolder.Text = "Output: $OutputDir"
$lblOutputFolder.Font = New-Object System.Drawing.Font("Arial", 9)
$lblOutputFolder.ForeColor = [System.Drawing.Color]::DarkGreen
$lblOutputFolder.Location = New-Object System.Drawing.Point(20, 120)
$lblOutputFolder.Size = New-Object System.Drawing.Size(800, 20)
$form.Controls.Add($lblOutputFolder)

# BOK Files Section
$lblBokFiles = New-Object System.Windows.Forms.Label
$lblBokFiles.Text = "BOK Files in Input Folder:"
$lblBokFiles.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblBokFiles.Location = New-Object System.Drawing.Point(20, 160)
$lblBokFiles.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($lblBokFiles)

$btnRefreshFiles = New-Object System.Windows.Forms.Button
$btnRefreshFiles.Text = "Refresh File List"
$btnRefreshFiles.Font = New-Object System.Drawing.Font("Arial", 10)
$btnRefreshFiles.Location = New-Object System.Drawing.Point(620, 155)
$btnRefreshFiles.Size = New-Object System.Drawing.Size(140, 30)
$btnRefreshFiles.BackColor = [System.Drawing.Color]::LightBlue
$form.Controls.Add($btnRefreshFiles)

$lstBokFiles = New-Object System.Windows.Forms.ListBox
$lstBokFiles.Location = New-Object System.Drawing.Point(20, 190)
$lstBokFiles.Size = New-Object System.Drawing.Size(740, 100)
$lstBokFiles.Font = New-Object System.Drawing.Font("Arial", 9)
$lstBokFiles.SelectionMode = "MultiExtended"
$form.Controls.Add($lstBokFiles)

# Folder Buttons
$btnOpenInputFolder = New-Object System.Windows.Forms.Button
$btnOpenInputFolder.Text = "Open Input Folder"
$btnOpenInputFolder.Font = New-Object System.Drawing.Font("Arial", 10)
$btnOpenInputFolder.Location = New-Object System.Drawing.Point(620, 300)
$btnOpenInputFolder.Size = New-Object System.Drawing.Size(140, 30)
$btnOpenInputFolder.BackColor = [System.Drawing.Color]::LightGreen
$form.Controls.Add($btnOpenInputFolder)

$btnOpenOutputFolder = New-Object System.Windows.Forms.Button
$btnOpenOutputFolder.Text = "Open Output Folder"
$btnOpenOutputFolder.Font = New-Object System.Drawing.Font("Arial", 10)
$btnOpenOutputFolder.Location = New-Object System.Drawing.Point(620, 340)
$btnOpenOutputFolder.Size = New-Object System.Drawing.Size(140, 30)
$btnOpenOutputFolder.BackColor = [System.Drawing.Color]::LightGreen
$form.Controls.Add($btnOpenOutputFolder)

# Progress Section
$lblProgress = New-Object System.Windows.Forms.Label
$lblProgress.Text = "Progress:"
$lblProgress.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblProgress.Location = New-Object System.Drawing.Point(20, 320)
$lblProgress.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($lblProgress)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 345)
$progressBar.Size = New-Object System.Drawing.Size(580, 25)
$progressBar.Style = "Blocks"
$form.Controls.Add($progressBar)

# Convert Button
$btnConvert = New-Object System.Windows.Forms.Button
$btnConvert.Text = "Start Conversion"
$btnConvert.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$btnConvert.Location = New-Object System.Drawing.Point(620, 380)
$btnConvert.Size = New-Object System.Drawing.Size(140, 40)
$btnConvert.BackColor = [System.Drawing.Color]::Orange
$btnConvert.ForeColor = [System.Drawing.Color]::White
$btnConvert.Enabled = $false
$form.Controls.Add($btnConvert)

# Clear Button
$btnClear = New-Object System.Windows.Forms.Button
$btnClear.Text = "Clear Log"
$btnClear.Font = New-Object System.Drawing.Font("Arial", 10)
$btnClear.Location = New-Object System.Drawing.Point(620, 430)
$btnClear.Size = New-Object System.Drawing.Size(140, 30)
$btnClear.BackColor = [System.Drawing.Color]::LightCoral
$form.Controls.Add($btnClear)

# Log Section
$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = "Activity Log:"
$lblLog.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblLog.Location = New-Object System.Drawing.Point(20, 390)
$lblLog.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($lblLog)

$txtLog = New-Object System.Windows.Forms.RichTextBox
$txtLog.Location = New-Object System.Drawing.Point(20, 415)
$txtLog.Size = New-Object System.Drawing.Size(580, 280)
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtLog.ReadOnly = $true
$txtLog.BackColor = [System.Drawing.Color]::Black
$txtLog.ForeColor = [System.Drawing.Color]::LimeGreen
$form.Controls.Add($txtLog)

# Helper Functions
function Log-Message {
    param([string]$message, [string]$color = "LimeGreen")
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $txtLog.SelectionStart = $txtLog.TextLength
    $txtLog.SelectionLength = 0
    $txtLog.SelectionColor = [System.Drawing.Color]::FromName($color)
    $txtLog.AppendText("[$timestamp] $message`n")
    $txtLog.ScrollToCaret()
    $form.Refresh()
}

function Refresh-FileList {
    $lstBokFiles.Items.Clear()
    $bokFiles = Get-ChildItem -Path $InputDir -Filter "*.bok" -ErrorAction SilentlyContinue
    
    if ($bokFiles.Count -eq 0) {
        $lstBokFiles.Items.Add("No .bok files found in input folder")
        $btnConvert.Enabled = $false
        Log-Message "No .bok files found in input folder" "Yellow"
    } else {
        foreach ($file in $bokFiles) {
            $lstBokFiles.Items.Add($file.Name)
        }
        $btnConvert.Enabled = $true
        Log-Message "Found $($bokFiles.Count) .bok files" "Cyan"
    }
}

# Enhanced conversion function
function Convert-FileEnhanced {
    param(
        [object]$accessApp,
        [string]$tempMdbPath,
        [string]$outputAccdbPath
    )
    
    try {
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
            
            # Transfer tables
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
                Log-Message "   Transferred $transferCount objects successfully" "Cyan"
                $conversionSuccess = $true
            }
        }
        catch {
            Log-Message "   Method 1 failed, trying alternative..." "Yellow"
        }
        
        # Method 2: ConvertAccessProject
        if (-not $conversionSuccess) {
            try {
                $accessApp.CloseCurrentDatabase()
                $accessApp.ConvertAccessProject($tempMdbPath, $outputAccdbPath, 12)
                $conversionSuccess = $true
                Log-Message "   Method 2 succeeded" "Cyan"
            }
            catch { }
        }
        
        # Method 3: CompactRepair
        if (-not $conversionSuccess) {
            try {
                $accessApp.CloseCurrentDatabase()
                $accessApp.CompactRepair($tempMdbPath, $outputAccdbPath, $false)
                $conversionSuccess = $true
                Log-Message "   Method 3 succeeded" "Cyan"
            }
            catch { }
        }
        
        return $conversionSuccess
    }
    catch {
        Log-Message "   Conversion error: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Event Handlers
$btnRefreshFiles.Add_Click({
    Refresh-FileList
})

$btnOpenInputFolder.Add_Click({
    Start-Process "explorer.exe" $InputDir
})

$btnOpenOutputFolder.Add_Click({
    Start-Process "explorer.exe" $OutputDir
})

$btnClear.Add_Click({
    $txtLog.Clear()
    Log-Message "Log cleared" "Yellow"
})

$btnConvert.Add_Click({
    $bokFiles = Get-ChildItem -Path $InputDir -Filter "*.bok" -ErrorAction SilentlyContinue
    
    if ($bokFiles.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No .bok files found in input folder!`nPlease copy your .bok files to the input folder first.", "Warning", 'OK', 'Warning')
        return
    }
    
    # Disable controls during conversion
    $btnRefreshFiles.Enabled = $false
    $btnConvert.Enabled = $false
    $btnClear.Enabled = $false
    
    $progressBar.Value = 0
    $progressBar.Maximum = $bokFiles.Count
    
    Log-Message "=== Starting Portable Conversion Process ===" "Yellow"
    
    # Start conversion
    $filesConverted = 0
    $filesSkipped = 0
    $filesError = 0
    
    try {
        Log-Message "Starting Microsoft Access..." "White"
        $accessApp = New-Object -ComObject Access.Application
        $accessApp.Visible = $false
        $accessApp.AutomationSecurity = 1
        
        for ($i = 0; $i -lt $bokFiles.Count; $i++) {
            $bokFile = $bokFiles[$i]
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($bokFile.Name)
            $tempMdbPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "$fileName.mdb")
            $outputAccdbPath = Join-Path $OutputDir "$fileName.accdb"
            
            Log-Message "Converting: $($bokFile.Name)..." "White"
            $progressBar.Value = $i + 1
            $form.Refresh()
            
            try {
                # Check if file already exists
                if (Test-Path $outputAccdbPath) {
                    Log-Message "   File already exists - Skipped" "Yellow"
                    $filesSkipped++
                    continue
                }
                
                # Copy .bok to temp as .mdb
                Copy-Item $bokFile.FullName $tempMdbPath -Force
                
                # Enhanced conversion
                $conversionResult = Convert-FileEnhanced $accessApp $tempMdbPath $outputAccdbPath
                
                # Clean up temp file
                if (Test-Path $tempMdbPath) {
                    Remove-Item $tempMdbPath -Force
                }
                
                if ($conversionResult) {
                    Log-Message "   Portable conversion successful!" "LimeGreen"
                    $filesConverted++
                } else {
                    Log-Message "   Portable conversion failed" "Red"
                    $filesError++
                }
            }
            catch {
                Log-Message "   Conversion failed: $($_.Exception.Message)" "Red"
                $filesError++
                
                # Clean up on error
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
        Log-Message "General error: $($_.Exception.Message)" "Red"
    }
    finally {
        # Close Access
        if ($accessApp) {
            try {
                $accessApp.Quit()
                [System.Runtime.InteropServices.Marshal]::ReleaseComObject($accessApp) | Out-Null
            }
            catch { }
        }
        
        # Update progress and show results
        $progressBar.Value = $progressBar.Maximum
        Log-Message "=== Portable Conversion Process Completed ===" "Yellow"
        Log-Message "Success: $filesConverted | Skipped: $filesSkipped | Failed: $filesError" "Cyan"
        
        if ($filesConverted -gt 0) {
            Log-Message "Converted files saved in output folder" "LimeGreen"
            
            $result = [System.Windows.Forms.MessageBox]::Show("Conversion completed successfully!`nDo you want to open the output folder?", "Complete", 'YesNo', 'Information')
            if ($result -eq 'Yes') {
                Start-Process "explorer.exe" $OutputDir
            }
        }
        
        # Re-enable controls
        $btnRefreshFiles.Enabled = $true
        $btnClear.Enabled = $true
        Refresh-FileList
    }
})

# Initialize form
$form.Add_Load({
    Log-Message "Welcome to BOK to ACCDB Converter - Portable Edition" "Yellow"
    Log-Message "This version works from any location!" "Cyan"
    Log-Message "Copy your .bok files to the input folder and click 'Refresh File List'" "White"
    Refresh-FileList
})

# Show the form
$form.ShowDialog() | Out-Null
