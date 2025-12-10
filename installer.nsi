; TabRefresher Extension Installer
; Uses NSIS (Nullsoft Scriptable Install System)
; 
; Build Instructions:
; 1. Install NSIS from https://nsis.sourceforge.io/
; 2. Right-click this file and select "Compile NSIS Script"
; 3. The installer exe will be generated in the same directory

!include "MUI2.nsh"

; Installer settings
Name "TabRefresher"
OutFile "TabRefresher-Installer.exe"
InstallDir "$PROGRAMFILES\TabRefresher"
RequestExecutionLevel user

; MUI Settings
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

; Get the directory where the installer script is located
!define SOURCEDIR "$%CD%"

; Installer sections
Section "Install Extension Files"
    SetOutPath "$INSTDIR"
    
    ; Copy main extension files
    File "background.js"
    File "manifest.json"
    File "popup.css"
    File "popup.html"
    File "popup.js"
    File "README.md"
    
    ; Copy icons directory if it exists
    ${If} ${FileExists} "icons\*.*"
        SetOutPath "$INSTDIR\icons"
        File "icons\*.*"
    ${EndIf}
    
    ; Create uninstaller
    SetOutPath "$INSTDIR"
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    ; Create Start Menu shortcuts
    CreateDirectory "$SMPROGRAMS\TabRefresher"
    CreateShortCut "$SMPROGRAMS\TabRefresher\Extension Folder.lnk" "$INSTDIR"
    CreateShortCut "$SMPROGRAMS\TabRefresher\Uninstall.lnk" "$INSTDIR\uninstall.exe"
    
    ; Show information
    MessageBox MB_ICONINFORMATION "TabRefresher installed successfully!$\r$\n$\r$\nNext steps:$\r$\n1. Open Google Chrome$\r$\n2. Go to chrome://extensions/$\r$\n3. Enable Developer mode$\r$\n4. Click Load unpacked$\r$\n5. Select: $INSTDIR"
    
SectionEnd

; Uninstaller section
Section "Uninstall"
    ; Remove extension files
    Delete "$INSTDIR\background.js"
    Delete "$INSTDIR\manifest.json"
    Delete "$INSTDIR\popup.css"
    Delete "$INSTDIR\popup.html"
    Delete "$INSTDIR\popup.js"
    Delete "$INSTDIR\README.md"
    Delete "$INSTDIR\uninstall.exe"
    
    ; Remove icons directory
    RMDir /r "$INSTDIR\icons"
    
    ; Remove installation directory
    RMDir "$INSTDIR"
    
    ; Remove Start Menu shortcuts
    RMDir /r "$SMPROGRAMS\TabRefresher"
    
    MessageBox MB_ICONINFORMATION "TabRefresher has been uninstalled."
    
SectionEnd
