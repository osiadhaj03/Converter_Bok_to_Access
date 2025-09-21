; Enhanced BOK Converter - NSIS Installer Script
; Creates a professional installer for the BOK to ACCDB Converter

!include "MUI2.nsh"

; General Settings
Name "Enhanced BOK to ACCDB Converter"
OutFile "..\dist\BokConverter_Setup.exe"
InstallDir "$PROGRAMFILES\Enhanced BOK Converter"
InstallDirRegKey HKLM "Software\Enhanced BOK Converter" "InstallPath"
RequestExecutionLevel admin

; Version Information
VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "Enhanced BOK to ACCDB Converter"
VIAddVersionKey "ProductVersion" "1.0.0"
VIAddVersionKey "CompanyName" "BOK Converter Team"
VIAddVersionKey "FileDescription" "Enhanced BOK to ACCDB Converter Installer"
VIAddVersionKey "FileVersion" "1.0.0.0"
VIAddVersionKey "LegalCopyright" "© 2024 BOK Converter Team"

; Interface Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\src\icon.ico"
!define MUI_UNICON "..\src\icon.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "..\src\header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\src\wizard.bmp"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\docs\LICENSE.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Languages
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Arabic"

; Main Installation Section
Section "Enhanced BOK Converter" SecMain
    SectionIn RO  ; Read only - always installed
    
    SetOutPath "$INSTDIR"
    
    ; Copy main executable
    File "..\dist\BokConverterGUI_Enhanced.exe"
    
    ; Copy documentation
    File "..\README.md"
    File "..\docs\installation-guide.md"
    File "..\docs\user-manual.md"
    
    ; Copy icon
    File "..\src\icon.ico"
    
    ; Registry entries
    WriteRegStr HKLM "Software\Enhanced BOK Converter" "InstallPath" "$INSTDIR"
    WriteRegStr HKLM "Software\Enhanced BOK Converter" "Version" "1.0.0"
    
    ; Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
    ; Add to Add/Remove Programs
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter" "DisplayName" "Enhanced BOK to ACCDB Converter"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter" "InstallLocation" "$INSTDIR"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter" "DisplayIcon" "$INSTDIR\icon.ico"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter" "Publisher" "BOK Converter Team"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter" "DisplayVersion" "1.0.0"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter" "NoRepair" 1
    
SectionEnd

; Desktop Shortcut Section
Section "Desktop Shortcut" SecDesktop
    CreateShortCut "$DESKTOP\Enhanced BOK Converter.lnk" "$INSTDIR\BokConverterGUI_Enhanced.exe" "" "$INSTDIR\icon.ico" 0
SectionEnd

; Start Menu Section
Section "Start Menu Shortcuts" SecStartMenu
    CreateDirectory "$SMPROGRAMS\Enhanced BOK Converter"
    CreateShortCut "$SMPROGRAMS\Enhanced BOK Converter\Enhanced BOK Converter.lnk" "$INSTDIR\BokConverterGUI_Enhanced.exe" "" "$INSTDIR\icon.ico" 0
    CreateShortCut "$SMPROGRAMS\Enhanced BOK Converter\User Manual.lnk" "$INSTDIR\user-manual.md"
    CreateShortCut "$SMPROGRAMS\Enhanced BOK Converter\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

; Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} "Main application files (required)"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "Create a desktop shortcut"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} "Create Start Menu shortcuts"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Uninstaller Section
Section "Uninstall"
    ; Remove files
    Delete "$INSTDIR\BokConverterGUI_Enhanced.exe"
    Delete "$INSTDIR\README.md"
    Delete "$INSTDIR\installation-guide.md"
    Delete "$INSTDIR\user-manual.md"
    Delete "$INSTDIR\icon.ico"
    Delete "$INSTDIR\Uninstall.exe"
    
    ; Remove shortcuts
    Delete "$DESKTOP\Enhanced BOK Converter.lnk"
    Delete "$SMPROGRAMS\Enhanced BOK Converter\Enhanced BOK Converter.lnk"
    Delete "$SMPROGRAMS\Enhanced BOK Converter\User Manual.lnk"
    Delete "$SMPROGRAMS\Enhanced BOK Converter\Uninstall.lnk"
    RMDir "$SMPROGRAMS\Enhanced BOK Converter"
    
    ; Remove registry entries
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Enhanced BOK Converter"
    DeleteRegKey HKLM "Software\Enhanced BOK Converter"
    
    ; Remove installation directory
    RMDir "$INSTDIR"
    
SectionEnd
    Exec "$INSTDIR\BokConverterGUI_Enhanced.ps1"
FunctionEnd