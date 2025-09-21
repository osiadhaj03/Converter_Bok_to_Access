[Setup]
AppName=BokConverter
AppVersion=1.0
DefaultDirName={pf}\BokConverter
DefaultGroupName=BokConverter
OutputDir=..\dist
OutputBaseFilename=BokConverterInstaller
SetupIconFile={src}\icon.ico
UninstallDisplayIcon={src}\icon.ico
Compression=lzma
SolidCompression=yes

[Files]
Source: "..\src\BokConverterGUI_Enhanced.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\src\icon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\src\manifest.xml"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\BokConverter"; Filename: "{app}\BokConverterGUI_Enhanced.ps1"
Name: "{group}\Uninstall BokConverter"; Filename: "{un}\unins000.exe"

[Run]
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\BokConverterGUI_Enhanced.ps1"""; Description: "Launch BokConverter"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\BokConverterGUI_Enhanced.ps1"""; Description: "Uninstall BokConverter"; Flags: nowait skipifsilent