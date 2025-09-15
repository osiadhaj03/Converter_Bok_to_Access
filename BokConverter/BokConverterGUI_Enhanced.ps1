# Enhanced BOK to ACCDB Converter - GUI Version
# PowerShell Script with Windows Forms - Enhanced conversion methods

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Enhanced BOK to ACCDB Converter"
$form.Size = New-Object System.Drawing.Size(800, 700)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::WhiteSmoke

# Title Label
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Enhanced BOK to ACCDB File Converter"
$lblTitle.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = [System.Drawing.Color]::DarkBlue
$lblTitle.Location = New-Object System.Drawing.Point(20, 20)
$lblTitle.Size = New-Object System.Drawing.Size(500, 30)
$form.Controls.Add($lblTitle)

# Subtitle Label
$lblSubtitle = New-Object System.Windows.Forms.Label
$lblSubtitle.Text = "Professional database conversion with full object support"
$lblSubtitle.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Italic)
$lblSubtitle.ForeColor = [System.Drawing.Color]::Gray
$lblSubtitle.Location = New-Object System.Drawing.Point(20, 50)
$lblSubtitle.Size = New-Object System.Drawing.Size(400, 20)
$form.Controls.Add($lblSubtitle)

# BOK Files Section
$lblBokFiles = New-Object System.Windows.Forms.Label
$lblBokFiles.Text = "Selected BOK Files:"
$lblBokFiles.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblBokFiles.Location = New-Object System.Drawing.Point(20, 90)
$lblBokFiles.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($lblBokFiles)

$btnSelectBokFiles = New-Object System.Windows.Forms.Button
$btnSelectBokFiles.Text = "Select BOK Files"
$btnSelectBokFiles.Font = New-Object System.Drawing.Font("Arial", 10)
$btnSelectBokFiles.Location = New-Object System.Drawing.Point(620, 85)
$btnSelectBokFiles.Size = New-Object System.Drawing.Size(140, 30)
$btnSelectBokFiles.BackColor = [System.Drawing.Color]::LightBlue
$form.Controls.Add($btnSelectBokFiles)

$lstBokFiles = New-Object System.Windows.Forms.ListBox
$lstBokFiles.Location = New-Object System.Drawing.Point(20, 120)
$lstBokFiles.Size = New-Object System.Drawing.Size(740, 100)
$lstBokFiles.Font = New-Object System.Drawing.Font("Arial", 9)
$lstBokFiles.SelectionMode = "MultiExtended"
$form.Controls.Add($lstBokFiles)

# Output Folder Section
$lblOutputFolder = New-Object System.Windows.Forms.Label
$lblOutputFolder.Text = "Output Folder:"
$lblOutputFolder.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblOutputFolder.Location = New-Object System.Drawing.Point(20, 240)
$lblOutputFolder.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($lblOutputFolder)

$txtOutputFolder = New-Object System.Windows.Forms.TextBox
$txtOutputFolder.Location = New-Object System.Drawing.Point(20, 265)
$txtOutputFolder.Size = New-Object System.Drawing.Size(580, 25)
$txtOutputFolder.Font = New-Object System.Drawing.Font("Arial", 9)
$txtOutputFolder.ReadOnly = $true
$txtOutputFolder.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($txtOutputFolder)

$btnSelectOutputFolder = New-Object System.Windows.Forms.Button
$btnSelectOutputFolder.Text = "Browse Folder"
$btnSelectOutputFolder.Font = New-Object System.Drawing.Font("Arial", 10)
$btnSelectOutputFolder.Location = New-Object System.Drawing.Point(620, 260)
$btnSelectOutputFolder.Size = New-Object System.Drawing.Size(140, 30)
$btnSelectOutputFolder.BackColor = [System.Drawing.Color]::LightGreen
$form.Controls.Add($btnSelectOutputFolder)

# Progress Section
$lblProgress = New-Object System.Windows.Forms.Label
$lblProgress.Text = "Progress:"
$lblProgress.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblProgress.Location = New-Object System.Drawing.Point(20, 310)
$lblProgress.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($lblProgress)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 335)
$progressBar.Size = New-Object System.Drawing.Size(580, 25)
$progressBar.Style = "Blocks"
$form.Controls.Add($progressBar)

# Convert Button
$btnConvert = New-Object System.Windows.Forms.Button
$btnConvert.Text = "Start Enhanced Convert"
$btnConvert.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
$btnConvert.Location = New-Object System.Drawing.Point(620, 320)
$btnConvert.Size = New-Object System.Drawing.Size(140, 40)
$btnConvert.BackColor = [System.Drawing.Color]::Orange
$btnConvert.ForeColor = [System.Drawing.Color]::White
$btnConvert.Enabled = $false
$form.Controls.Add($btnConvert)

# Clear Button
$btnClear = New-Object System.Windows.Forms.Button
$btnClear.Text = "Clear All"
$btnClear.Font = New-Object System.Drawing.Font("Arial", 10)
$btnClear.Location = New-Object System.Drawing.Point(620, 370)
$btnClear.Size = New-Object System.Drawing.Size(140, 30)
$btnClear.BackColor = [System.Drawing.Color]::LightCoral
$form.Controls.Add($btnClear)

# Log Section
$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = "Activity Log:"
$lblLog.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblLog.Location = New-Object System.Drawing.Point(20, 420)
$lblLog.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($lblLog)

$txtLog = New-Object System.Windows.Forms.RichTextBox
$txtLog.Location = New-Object System.Drawing.Point(20, 445)
$txtLog.Size = New-Object System.Drawing.Size(740, 180)
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

function Update-ConvertButton {
    $btnConvert.Enabled = ($lstBokFiles.Items.Count -gt 0) -and (-not [string]::IsNullOrEmpty($txtOutputFolder.Text))
}

# Enhanced conversion function
function Convert-FileEnhanced {
    param(
        [object]$accessApp,
        [string]$tempMdbPath,
        [string]$outputAccdbPath
    )
    
    try {
        # Open the MDB database
        $accessApp.OpenCurrentDatabase($tempMdbPath, $false)
        
        # Method 1: Try TransferDatabase method (most reliable)
        try {
            # Create new ACCDB database with correct enum
            $accessApp.NewCurrentDatabase($outputAccdbPath, [Microsoft.Office.Interop.Access.AcNewDatabaseFormat]::acNewDatabaseFormatAccess2007)
            $accessApp.CloseCurrentDatabase()
            
            # Reopen source database
            $accessApp.OpenCurrentDatabase($tempMdbPath, $false)
            
            # Transfer all objects
            $transferCount = 0
            
            # Get all tables (excluding system tables)
            $tables = $accessApp.CurrentData.AllTables
            foreach ($table in $tables) {
                if (-not $table.Name.StartsWith("MSys")) {
                    try {
                        $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 0, $table.Name, $table.Name, $false)
                        $transferCount++
                    }
                    catch {
                        Log-Message "   Warning: Could not transfer table $($table.Name)" "Yellow"
                    }
                }
            }
            
            # Get all queries
            $queries = $accessApp.CurrentData.AllQueries
            foreach ($query in $queries) {
                try {
                    $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 1, $query.Name, $query.Name, $false)
                    $transferCount++
                }
                catch {
                    Log-Message "   Warning: Could not transfer query $($query.Name)" "Yellow"
                }
            }
            
            # Get all forms
            $forms = $accessApp.CurrentProject.AllForms
            foreach ($form in $forms) {
                try {
                    $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 2, $form.Name, $form.Name, $false)
                    $transferCount++
                }
                catch {
                    Log-Message "   Warning: Could not transfer form $($form.Name)" "Yellow"
                }
            }
            
            # Get all reports
            $reports = $accessApp.CurrentProject.AllReports
            foreach ($report in $reports) {
                try {
                    $accessApp.DoCmd.TransferDatabase(0, "Microsoft.ACE.OLEDB.12.0", $outputAccdbPath, 3, $report.Name, $report.Name, $false)
                    $transferCount++
                }
                catch {
                    Log-Message "   Warning: Could not transfer report $($report.Name)" "Yellow"
                }
            }
            
            $accessApp.CloseCurrentDatabase()
            Log-Message "   Transferred $transferCount objects successfully" "Cyan"
            return $true
        }
        catch {
            Log-Message "   Method 1 failed, trying alternative method..." "Yellow"
            
            # Method 2: Try ConvertAccessProject
            try {
                $accessApp.CloseCurrentDatabase()
                $accessApp.ConvertAccessProject($tempMdbPath, $outputAccdbPath, 12)
                return $true
            }
            catch {
                # Method 3: Try CompactRepair as last resort
                try {
                    $accessApp.CloseCurrentDatabase()
                    $accessApp.CompactRepair($tempMdbPath, $outputAccdbPath, $false)
                    return $true
                }
                catch {
                    return $false
                }
            }
        }
    }
    catch {
        Log-Message "   Conversion error: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Event Handlers
$btnSelectBokFiles.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = "Select BOK Files"
    $openFileDialog.Filter = "BOK Files (*.bok)|*.bok|All Files (*.*)|*.*"
    $openFileDialog.Multiselect = $true
    $openFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    
    if ($openFileDialog.ShowDialog() -eq 'OK') {
        $lstBokFiles.Items.Clear()
        foreach ($fileName in $openFileDialog.FileNames) {
            $lstBokFiles.Items.Add($fileName)
        }
        Log-Message "Selected $($openFileDialog.FileNames.Count) BOK files" "Cyan"
        Update-ConvertButton
    }
})

$btnSelectOutputFolder.Add_Click({
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Select output folder for converted files"
    $folderDialog.ShowNewFolderButton = $true
    
    if ($folderDialog.ShowDialog() -eq 'OK') {
        $txtOutputFolder.Text = $folderDialog.SelectedPath
        Log-Message "Output folder: $($folderDialog.SelectedPath)" "Cyan"
        Update-ConvertButton
    }
})

$btnClear.Add_Click({
    $lstBokFiles.Items.Clear()
    $txtLog.Clear()
    $progressBar.Value = 0
    Update-ConvertButton
    Log-Message "All data cleared" "Yellow"
})

$btnConvert.Add_Click({
    if ($lstBokFiles.Items.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select BOK files first", "Warning", 'OK', 'Warning')
        return
    }
    
    if ([string]::IsNullOrEmpty($txtOutputFolder.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Please select output folder first", "Warning", 'OK', 'Warning')
        return
    }
    
    # Create output directory if it doesn't exist
    try {
        if (-not (Test-Path $txtOutputFolder.Text)) {
            New-Item -ItemType Directory -Path $txtOutputFolder.Text -Force | Out-Null
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error creating output folder: $($_.Exception.Message)", "Error", 'OK', 'Error')
        return
    }
    
    # Disable controls during conversion
    $btnSelectBokFiles.Enabled = $false
    $btnSelectOutputFolder.Enabled = $false
    $btnConvert.Enabled = $false
    $btnClear.Enabled = $false
    
    $progressBar.Value = 0
    $progressBar.Maximum = $lstBokFiles.Items.Count
    
    Log-Message "=== Starting Enhanced Conversion Process ===" "Yellow"
    
    # Start conversion
    $filesConverted = 0
    $filesSkipped = 0
    $filesError = 0
    
    try {
        Log-Message "Starting Microsoft Access..." "White"
        $accessApp = New-Object -ComObject Access.Application
        $accessApp.Visible = $false
        $accessApp.AutomationSecurity = 1  # msoAutomationSecurityLow
        
        for ($i = 0; $i -lt $lstBokFiles.Items.Count; $i++) {
            $bokFilePath = $lstBokFiles.Items[$i]
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($bokFilePath)
            $tempMdbPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "$fileName.mdb")
            $outputAccdbPath = Join-Path $txtOutputFolder.Text "$fileName.accdb"
            
            Log-Message "Converting: $([System.IO.Path]::GetFileName($bokFilePath))..." "White"
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
                Copy-Item $bokFilePath $tempMdbPath -Force
                
                # Enhanced conversion
                $conversionResult = Convert-FileEnhanced $accessApp $tempMdbPath $outputAccdbPath
                
                # Clean up temp file
                if (Test-Path $tempMdbPath) {
                    Remove-Item $tempMdbPath -Force
                }
                
                if ($conversionResult) {
                    Log-Message "   Enhanced conversion successful!" "LimeGreen"
                    $filesConverted++
                } else {
                    Log-Message "   Enhanced conversion failed" "Red"
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
        Log-Message "=== Enhanced Conversion Process Completed ===" "Yellow"
        Log-Message "Success: $filesConverted | Skipped: $filesSkipped | Failed: $filesError" "Cyan"
        
        if ($filesConverted -gt 0) {
            Log-Message "Enhanced converted files saved in: $($txtOutputFolder.Text)" "LimeGreen"
            
            $result = [System.Windows.Forms.MessageBox]::Show("Enhanced conversion completed successfully!`nDo you want to open the output folder?", "Complete", 'YesNo', 'Information')
            if ($result -eq 'Yes') {
                Start-Process "explorer.exe" $txtOutputFolder.Text
            }
        }
        
        # Re-enable controls
        $btnSelectBokFiles.Enabled = $true
        $btnSelectOutputFolder.Enabled = $true
        $btnClear.Enabled = $true
        Update-ConvertButton
    }
})

# Initialize form
$form.Add_Load({
    Log-Message "Welcome to Enhanced BOK to ACCDB Converter" "Yellow"
    Log-Message "This version uses professional conversion methods for better results" "Cyan"
    Log-Message "Select BOK files and output folder, then click 'Start Enhanced Convert'" "White"
    
    # Set default output folder
    $defaultOutput = Join-Path ([Environment]::GetFolderPath('Desktop')) "Enhanced_Converted_ACCDB"
    $txtOutputFolder.Text = $defaultOutput
})

# Show the form
$form.ShowDialog() | Out-Null
