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

## Development & AI Assistance

This project was developed with assistance from AI tools:

### ChatGPT's Role
- **Initial Architecture Design**: Helped design the Chrome extension structure using Manifest V3
- **Core Logic Implementation**: Assisted in writing the background service worker for managing timers and refresh logic
- **UI/UX Guidance**: Provided recommendations for user interface design and user experience improvements
- **Documentation**: Helped create comprehensive documentation and usage instructions
- **Feature Enhancement**: Suggested and implemented features like hard refresh, dark mode, and live countdown timer

### GitHub Copilot's Role
- **Code Completion**: Provided intelligent code suggestions and auto-completion throughout development
- **Function Generation**: Assisted in generating utility functions for time conversions and countdown calculations
- **Bug Fixing**: Helped identify and resolve issues with Chrome API usage
- **Code Style**: Ensured consistent code formatting and best practices across all JavaScript files
- **Cross-File References**: Helped maintain consistency between popup.js and background.js message passing

### How They Worked Together
1. **ChatGPT** provided the high-level architecture and problem-solving approach
2. **GitHub Copilot** accelerated the implementation with contextual code suggestions
3. **ChatGPT** reviewed and refined the generated code for quality and correctness
4. **GitHub Copilot** helped optimize and clean up the final code

This collaborative approach between AI assistants and human judgment resulted in a robust, well-structured extension that follows Chrome extension best practices.

## Version

Version 1.2

## License

This project is open source. Feel free to modify and distribute as needed.
