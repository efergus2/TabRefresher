@echo off
REM TabRefresher Extension Installer
REM This script helps set up the extension in Chrome

setlocal enabledelayedexpansion

cls
echo.
echo ==========================================
echo   TabRefresher Extension Installer
echo ==========================================
echo.

REM Get the directory where this script is located
set INSTALL_DIR=%~dp0

echo Installation Directory: %INSTALL_DIR%
echo.

REM Verify extension files exist
if not exist "%INSTALL_DIR%manifest.json" (
    echo ERROR: manifest.json not found!
    echo Please ensure you're running this from the TabRefresher folder.
    pause
    exit /b 1
)

echo Checking for extension files...
if not exist "%INSTALL_DIR%background.js" echo WARNING: background.js not found
if not exist "%INSTALL_DIR%popup.js" echo WARNING: popup.js not found
if not exist "%INSTALL_DIR%popup.html" echo WARNING: popup.html not found
if not exist "%INSTALL_DIR%popup.css" echo WARNING: popup.css not found

echo.
echo ==========================================
echo   Installation Instructions
echo ==========================================
echo.
echo 1. Open Google Chrome
echo 2. Go to: chrome://extensions/
echo 3. Enable "Developer mode" (toggle in top right)
echo 4. Click "Load unpacked"
echo 5. Select this folder: %INSTALL_DIR%
echo.
echo.

REM Try to open Chrome extensions page
for /f "tokens=*" %%i in ('powershell -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty '(Default)' -ErrorAction SilentlyContinue"') do (
    if exist "%%i" (
        echo Opening Chrome...
        start "" "%%i" "chrome://extensions/"
        timeout /t 2
    )
)

echo.
pause
