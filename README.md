# TabRefresher


A lightweight Chrome extension that automatically refreshes web pages at specified intervals for a defined duration.

## Features

- **Custom Refresh Intervals**: Set refresh frequency in seconds, minutes, or hours
- **Configurable Duration**: Define how long the auto-refresh should run (minutes or hours)
- **Hard Refresh Option**: Toggle between normal refresh and hard refresh (Ctrl+Shift+R) to bypass cache
- **Dark Mode**: Built-in dark mode support for comfortable viewing
- **Live Countdown**: Real-time countdown display showing remaining refresh time
- **Persistent State**: Timers continue running even after closing the popup
- **Tab Isolation**: Each tab maintains its own independent refresh timer

## Installation

### Quick Install (Recommended)

#### Option 1: Using the Installer Executable
1. Download `TabRefresher-Installer.exe` from the [Releases](../../releases) page
2. Run the installer and follow the prompts
3. The installer will place files in your Program Files directory
4. At the end of installation, you'll see instructions to complete setup in Chrome
5. Open Chrome and navigate to `chrome://extensions/`
6. Enable **Developer mode** (toggle in top right)
7. Click **Load unpacked** and select the installation directory shown in the installer message

#### Option 2: Using PowerShell Script
1. Download or clone this repository
2. Open PowerShell as Administrator
3. Navigate to the TabRefresher folder
4. Run: `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`
5. Run: `.\install.ps1`
6. Follow the on-screen instructions

#### Option 3: Using Batch Script
1. Download or clone this repository
2. Double-click `install.bat`
3. Follow the on-screen instructions

#### Option 4: Manual Installation
1. Clone or download this repository
2. Open Chrome and navigate to `chrome://extensions/`
3. Enable **Developer mode** (toggle in the top right)
4. Click **Load unpacked** and select the TabRefresher folder
5. The extension will appear in your Chrome toolbar

### Building the Installer from Source

To build the `.exe` installer yourself:

1. Download and install [NSIS](https://nsis.sourceforge.io/) (Nullsoft Scriptable Install System)
2. Clone or download this repository
3. Right-click `installer.nsi` and select **"Compile NSIS Script"**
4. The installer `TabRefresher-Installer.exe` will be generated in the same directory
5. Distribute the `.exe` file for easy installation

### Manual Installation

1. Clone or download this repository
2. Open Chrome and navigate to `chrome://extensions/`
3. Enable **Developer mode** (toggle in the top right)
4. Click **Load unpacked** and select the TabRefresher folder
5. The extension will appear in your Chrome toolbar

## Usage

1. Click the **TabRefresher icon** in your Chrome toolbar
2. **Set the Interval**: Choose how frequently the page should refresh (e.g., 5 seconds)
3. **Set the Duration**: Choose how long to keep refreshing (e.g., 1 hour)
4. **(Optional) Enable Hard Refresh**: Check to clear cache on each refresh
5. **(Optional) Enable Dark Mode**: Check for dark theme
6. Click **Start** to begin auto-refresh
7. Click **Stop** to cancel auto-refresh at any time

## How It Works

- **manifest.json**: Defines extension metadata and permissions (Manifest V3)
- **popup.html**: User interface for setting refresh parameters
- **popup.js**: Handles user interactions and displays live countdown
- **background.js**: Manages the actual tab refreshing and timer logic
- **popup.css**: Styles for the popup interface

## Technical Details

### Permissions

- `tabs`: Access to browser tabs for refresh operations
- `scripting`: Execute refresh commands
- `storage`: Store user preferences and timer states

### Architecture

The extension uses Chrome's message passing API to communicate between the popup and background service worker. Timer data is persisted in Chrome's local storage, allowing timers to continue running even after the popup closes.

## Version

Version 1.2

## License

This project is open source. Feel free to modify and distribute as needed.

## AI Usage

With help from ChatGPT and Github Copilot
