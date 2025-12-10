# TabRefresher Extension Installer (PowerShell)
# This script helps install and load the extension in Chrome

param(
    [switch]$Auto = $false
)

$ErrorActionPreference = "Stop"

# Get the script location
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$extensionDir = $scriptPath

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   TabRefresher Extension Installer" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check for required files
$requiredFiles = @("manifest.json", "background.js", "popup.js", "popup.html", "popup.css")
$allFilesExist = $true

Write-Host "Checking for extension files..." -ForegroundColor Yellow
foreach ($file in $requiredFiles) {
    $path = Join-Path $extensionDir $file
    if (Test-Path $path) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file (MISSING)" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Host ""
    Write-Host "ERROR: Some required files are missing!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Extension directory: $extensionDir" -ForegroundColor Green
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Installation Steps" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Open Google Chrome"
Write-Host "2. Go to: chrome://extensions/"
Write-Host "3. Enable 'Developer mode' (toggle in the top right)"
Write-Host "4. Click 'Load unpacked'"
Write-Host "5. Select this folder:"
Write-Host "   $extensionDir" -ForegroundColor Green
Write-Host ""
Write-Host "The extension will then appear in your Chrome toolbar!"
Write-Host ""

# Try to open Chrome and extensions page
try {
    $chromePath = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "(Default)"
    
    if ($chromePath -and (Test-Path $chromePath)) {
        Write-Host "Opening Chrome extensions page..." -ForegroundColor Yellow
        Start-Process $chromePath -ArgumentList "chrome://extensions/" -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
} catch {
    Write-Host "Note: Could not automatically open Chrome. Please open it manually." -ForegroundColor Yellow
}

Write-Host ""
if (-not $Auto) {
    $response = Read-Host "Press Enter when you've loaded the extension to complete installation"
}

Write-Host ""
Write-Host "Installation complete! Enjoy TabRefresher!" -ForegroundColor Green
Write-Host ""
