# Simple script to create a basic icon file
# This creates a simple ICO file from text

Add-Type -AssemblyName System.Drawing

# Create a bitmap
$bitmap = New-Object System.Drawing.Bitmap(32, 32)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Fill with background
$graphics.Clear([System.Drawing.Color]::DarkBlue)

# Draw some text/shape
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$font = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Bold)
$graphics.DrawString("BOK", $font, $brush, 2, 10)

# Save as ICO (basic)
$iconPath = Join-Path $PSScriptRoot "icon.ico"
$bitmap.Save($iconPath, [System.Drawing.Imaging.ImageFormat]::Icon)

$graphics.Dispose()
$bitmap.Dispose()

Write-Host "Icon created at: $iconPath"