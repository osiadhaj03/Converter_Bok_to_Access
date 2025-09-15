# BOK to ACCDB Converter - GUI Version
# PowerShell Script with Windows Forms

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "BOK to ACCDB Converter - محول ملفات BOK إلى ACCDB"
$form.Size = New-Object System.Drawing.Size(800, 700)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::WhiteSmoke

# Title Label
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "محول ملفات BOK إلى ACCDB"
$lblTitle.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = [System.Drawing.Color]::DarkBlue
$lblTitle.Location = New-Object System.Drawing.Point(20, 20)
$lblTitle.Size = New-Object System.Drawing.Size(400, 30)
$form.Controls.Add($lblTitle)

# BOK Files Section
$lblBokFiles = New-Object System.Windows.Forms.Label
$lblBokFiles.Text = "ملفات BOK المحددة:"
$lblBokFiles.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$lblBokFiles.Location = New-Object System.Drawing.Point(20, 70)
$lblBokFiles.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($lblBokFiles)

$btnSelectBokFiles = New-Object System.Windows.Forms.Button
$btnSelectBokFiles.Text = "اختيار ملفات BOK"
$btnSelectBokFiles.Font = New-Object System.Drawing.Font("Arial", 10)
$btnSelectBokFiles.Location = New-Object System.Drawing.Point(620, 65)
$btnSelectBokFiles.Size = New-Object System.Drawing.Size(140, 30)
$btnSelectBokFiles.BackColor = [System.Drawing.Color]::LightBlue
$form.Controls.Add($btnSelectBokFiles)

$lstBokFiles = New-Object System.Windows.Forms.ListBox
$lstBokFiles.Location = New-Object System.Drawing.Point(20, 100)
$lstBokFiles.Size = New-Object System.Drawing.Size(740, 120)
$lstBokFiles.Font = New-Object System.Drawing.Font("Arial", 9)
$lstBokFiles.SelectionMode = "MultiExtended"
$form.Controls.Add($lstBokFiles)

# Output Folder Section
$lblOutputFolder = New-Object System.Windows.Forms.Label
$lblOutputFolder.Text = "مجلد الحفظ:"
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
$btnSelectOutputFolder.Text = "اختيار المجلد"
$btnSelectOutputFolder.Font = New-Object System.Drawing.Font("Arial", 10)
$btnSelectOutputFolder.Location = New-Object System.Drawing.Point(620, 260)
$btnSelectOutputFolder.Size = New-Object System.Drawing.Size(140, 30)
$btnSelectOutputFolder.BackColor = [System.Drawing.Color]::LightGreen
$form.Controls.Add($btnSelectOutputFolder)

# Progress Section
$lblProgress = New-Object System.Windows.Forms.Label
$lblProgress.Text = "تقدم العملية:"
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
$btnConvert.Text = "بدء التحويل"
$btnConvert.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$btnConvert.Location = New-Object System.Drawing.Point(620, 320)
$btnConvert.Size = New-Object System.Drawing.Size(140, 40)
$btnConvert.BackColor = [System.Drawing.Color]::Orange
$btnConvert.ForeColor = [System.Drawing.Color]::White
$btnConvert.Enabled = $false
$form.Controls.Add($btnConvert)

# Clear Button
$btnClear = New-Object System.Windows.Forms.Button
$btnClear.Text = "مسح الكل"
$btnClear.Font = New-Object System.Drawing.Font("Arial", 10)
$btnClear.Location = New-Object System.Drawing.Point(620, 370)
$btnClear.Size = New-Object System.Drawing.Size(140, 30)
$btnClear.BackColor = [System.Drawing.Color]::LightCoral
$form.Controls.Add($btnClear)

# Log Section
$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = "سجل العمليات:"
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

# Event Handlers
$btnSelectBokFiles.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = "اختيار ملفات BOK"
    $openFileDialog.Filter = "BOK Files (*.bok)|*.bok|All Files (*.*)|*.*"
    $openFileDialog.Multiselect = $true
    $openFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    
    if ($openFileDialog.ShowDialog() -eq 'OK') {
        $lstBokFiles.Items.Clear()
        foreach ($fileName in $openFileDialog.FileNames) {
            $lstBokFiles.Items.Add($fileName)
        }
        Log-Message "تم اختيار $($openFileDialog.FileNames.Count) ملف BOK" "Cyan"
        Update-ConvertButton
    }
})

$btnSelectOutputFolder.Add_Click({
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "اختيار مجلد حفظ الملفات المحولة"
    $folderDialog.ShowNewFolderButton = $true
    
    if ($folderDialog.ShowDialog() -eq 'OK') {
        $txtOutputFolder.Text = $folderDialog.SelectedPath
        Log-Message "مجلد الحفظ: $($folderDialog.SelectedPath)" "Cyan"
        Update-ConvertButton
    }
})

$btnClear.Add_Click({
    $lstBokFiles.Items.Clear()
    $txtLog.Clear()
    $progressBar.Value = 0
    Update-ConvertButton
    Log-Message "تم مسح جميع البيانات" "Yellow"
})

$btnConvert.Add_Click({
    if ($lstBokFiles.Items.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("يرجى اختيار ملفات BOK أولاً", "تنبيه", 'OK', 'Warning')
        return
    }
    
    if ([string]::IsNullOrEmpty($txtOutputFolder.Text)) {
        [System.Windows.Forms.MessageBox]::Show("يرجى اختيار مجلد الحفظ أولاً", "تنبيه", 'OK', 'Warning')
        return
    }
    
    # Create output directory if it doesn't exist
    try {
        if (-not (Test-Path $txtOutputFolder.Text)) {
            New-Item -ItemType Directory -Path $txtOutputFolder.Text -Force | Out-Null
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("خطأ في إنشاء مجلد الحفظ: $($_.Exception.Message)", "خطأ", 'OK', 'Error')
        return
    }
    
    # Disable controls during conversion
    $btnSelectBokFiles.Enabled = $false
    $btnSelectOutputFolder.Enabled = $false
    $btnConvert.Enabled = $false
    $btnClear.Enabled = $false
    
    $progressBar.Value = 0
    $progressBar.Maximum = $lstBokFiles.Items.Count
    
    Log-Message "=== بدء عملية التحويل ===" "Yellow"
    
    # Start conversion
    $filesConverted = 0
    $filesSkipped = 0
    $filesError = 0
    
    try {
        Log-Message "تشغيل Microsoft Access..." "White"
        $accessApp = New-Object -ComObject Access.Application
        $accessApp.Visible = $false
        
        for ($i = 0; $i -lt $lstBokFiles.Items.Count; $i++) {
            $bokFilePath = $lstBokFiles.Items[$i]
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($bokFilePath)
            $tempMdbPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "$fileName.mdb")
            $outputAccdbPath = Join-Path $txtOutputFolder.Text "$fileName.accdb"
            
            Log-Message "تحويل: $([System.IO.Path]::GetFileName($bokFilePath))..." "White"
            $progressBar.Value = $i
            $form.Refresh()
            
            try {
                # Check if file already exists
                if (Test-Path $outputAccdbPath) {
                    Log-Message "   الملف موجود مسبقاً - تم التجاهل" "Yellow"
                    $filesSkipped++
                    continue
                }
                
                # Copy .bok to temp as .mdb
                Copy-Item $bokFilePath $tempMdbPath -Force
                
                # Convert using CompactRepair
                $accessApp.CompactRepair($tempMdbPath, $outputAccdbPath, $false)
                
                # Clean up temp file
                if (Test-Path $tempMdbPath) {
                    Remove-Item $tempMdbPath -Force
                }
                
                Log-Message "   نجح التحويل ✓" "LimeGreen"
                $filesConverted++
            }
            catch {
                Log-Message "   فشل التحويل: $($_.Exception.Message)" "Red"
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
        Log-Message "خطأ عام: $($_.Exception.Message)" "Red"
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
        Log-Message "=== انتهت عملية التحويل ===" "Yellow"
        Log-Message "نجح: $filesConverted | تجوهل: $filesSkipped | فشل: $filesError" "Cyan"
        
        if ($filesConverted -gt 0) {
            Log-Message "الملفات المحولة في: $($txtOutputFolder.Text)" "LimeGreen"
            
            $result = [System.Windows.Forms.MessageBox]::Show("تم التحويل بنجاح!`nهل تريد فتح مجلد الملفات المحولة؟", "مكتمل", 'YesNo', 'Information')
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
    Log-Message "مرحباً بك في محول ملفات BOK إلى ACCDB" "Yellow"
    Log-Message "اختر ملفات BOK ومجلد الحفظ ثم اضغط 'بدء التحويل'" "White"
    
    # Set default output folder
    $defaultOutput = Join-Path ([Environment]::GetFolderPath('Desktop')) "Converted_ACCDB"
    $txtOutputFolder.Text = $defaultOutput
})

# Show the form
$form.ShowDialog() | Out-Null
