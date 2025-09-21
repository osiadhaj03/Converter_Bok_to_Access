# PowerShell script to package the application files for distribution

$sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "..\src"
$distPath = Join-Path -Path $PSScriptRoot -ChildPath "..\dist"
$packageName = "BokConverter-Distribution"
$version = "1.0.0"

# Create the distribution directory if it doesn't exist
if (-not (Test-Path -Path $distPath)) {
    New-Item -ItemType Directory -Path $distPath | Out-Null
}

# Define the files to package
$filesToPackage = @(
    Join-Path -Path $sourcePath -ChildPath "BokConverterGUI_Enhanced.ps1",
    Join-Path -Path $sourcePath -ChildPath "icon.ico",
    Join-Path -Path $sourcePath -ChildPath "manifest.xml"
)

# Create a zip file for distribution
$zipFilePath = Join-Path -Path $distPath -ChildPath "$packageName-$version.zip"

if (Test-Path -Path $zipFilePath) {
    Remove-Item -Path $zipFilePath -Force
}

# Package the files into a zip archive
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($sourcePath, $zipFilePath)

Write-Host "Packaging completed. The files are available in: $zipFilePath"