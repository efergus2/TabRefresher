; TabRefresher Extension Installer
; Uses NSIS (Nullsoft Scriptable Install System)

!include "MUI2.nsh"
!include "x64.nsh"

; Installer and uninstaller settings
Name "TabRefresher Extension"
OutFile "TabRefresher-Installer.exe"
InstallDir "$PROGRAMFILES\TabRefresher"
InstallDirRegKey HKCU "Software\TabRefresher" "InstallDir"

; Request admin privileges
RequestExecutionLevel user

; MUI Settings
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

; Installer sections
Section "Install Extension Files"
    SetOutPath "$INSTDIR"
    
    ; Copy extension files
    File "background.js"
    File "manifest.json"
    File "popup.css"
    File "popup.html"
    File "popup.js"
    File "README.md"
    
    ; Copy icons directory
    SetOutPath "$INSTDIR\icons"
    File "icons\*.*"
    
    ; Save install directory to registry
    SetOutPath "$INSTDIR"
    WriteRegStr HKCU "Software\TabRefresher" "InstallDir" "$INSTDIR"
    
    ; Create uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    ; Create Start Menu shortcuts
    CreateDirectory "$SMPROGRAMS\TabRefresher"
    CreateShortCut "$SMPROGRAMS\TabRefresher\Uninstall.lnk" "$INSTDIR\uninstall.exe"
    CreateShortCut "$SMPROGRAMS\TabRefresher\Extension Folder.lnk" "$INSTDIR"
    CreateShortCut "$SMPROGRAMS\TabRefresher\README.lnk" "$INSTDIR\README.md"
    
SectionEnd

Section "Load Extension in Chrome"
    ; Create and execute a PowerShell script to load the extension
    FileOpen $0 "$INSTDIR\load-extension.ps1" w
    FileWrite $0 "# This script loads TabRefresher as an unpacked extension in Chrome$\r$\n"
    FileWrite $0 "`$extensionPath = '$INSTDIR'$\r$\n"
    FileWrite $0 "Write-Host 'TabRefresher installed at:' $extensionPath$\r$\n"
    FileWrite $0 "Write-Host ''$\r$\n"
    FileWrite $0 "Write-Host 'To complete installation in Chrome:'$\r$\n"
    FileWrite $0 "Write-Host '1. Go to chrome://extensions/'$\r$\n"
    FileWrite $0 "Write-Host '2. Enable Developer mode (top right)'$\r$\n"
    FileWrite $0 "Write-Host '3. Click Load unpacked'$\r$\n"
    FileWrite $0 "Write-Host '4. Select this folder: ' $extensionPath$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "Write-Host 'Installation complete!'$\r$\n"
    FileWrite $0 "Write-Host ''$\r$\n"
    FileWrite $0 "Read-Host 'Press Enter to continue'"
    FileClose $0
    
SectionEnd

; Uninstaller section
Section "Uninstall"
    ; Remove files
    Delete "$INSTDIR\background.js"
    Delete "$INSTDIR\manifest.json"
    Delete "$INSTDIR\popup.css"
    Delete "$INSTDIR\popup.html"
    Delete "$INSTDIR\popup.js"
    Delete "$INSTDIR\README.md"
    Delete "$INSTDIR\load-extension.ps1"
    Delete "$INSTDIR\uninstall.exe"
    
    ; Remove icons directory
    RMDir /r "$INSTDIR\icons"
    
    ; Remove installation directory
    RMDir "$INSTDIR"
    
    ; Remove registry keys
    DeleteRegKey HKCU "Software\TabRefresher"
    
    ; Remove Start Menu shortcuts
    RMDir /r "$SMPROGRAMS\TabRefresher"
    
SectionEnd
