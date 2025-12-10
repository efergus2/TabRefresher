// Load dark mode preference
chrome.storage.sync.get("darkMode", (data) => {
    if (data.darkMode) {
        document.body.classList.add("dark");
        document.getElementById("dark-mode-checkbox").checked = true;
    }
});

// Toggle dark mode
document.getElementById("dark-mode-checkbox").addEventListener("change", (e) => {
    const enabled = e.target.checked;
    if (enabled) document.body.classList.add("dark");
    else document.body.classList.remove("dark");
    chrome.storage.sync.set({ darkMode: enabled });
});

let countdownInterval = null;

// Start live countdown
function startCountdown(endTime) {
    if (countdownInterval) clearInterval(countdownInterval);

    countdownInterval = setInterval(() => {
        const remaining = Math.max(0, Math.ceil((endTime - Date.now()) / 1000));
        if (remaining <= 0) {
            clearInterval(countdownInterval);
            document.getElementById("status").textContent = "Stopped.";
        } else {
            const minutes = Math.floor(remaining / 60);
            const seconds = remaining % 60;
            document.getElementById("status").textContent = `Running (${minutes}m ${seconds}s left)`;
        }
    }, 1000);
}

// Update status on popup load (syncing if already running)
function updateStatus() {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        const tab = tabs[0];
        chrome.storage.local.get("activeTimers", (data) => {
            const timers = data.activeTimers || {};
            if (timers[tab.id]) {
                document.getElementById("status").textContent = "Syncing...";
                startCountdown(timers[tab.id].endTime);
            } else {
                document.getElementById("status").textContent = "Stopped.";
                if (countdownInterval) clearInterval(countdownInterval);
            }
        });
    });
}

// Populate the Active Tabs list
function updateActiveTabsList() {
    const container = document.getElementById("active-tabs");
    container.innerHTML = "";

    chrome.storage.local.get("activeTimers", (data) => {
        const timers = data.activeTimers || {};
        const tabIds = Object.keys(timers);

        if (tabIds.length === 0) {
            container.textContent = "No active tabs.";
            return;
        }

        tabIds.forEach((id) => {
            const tabId = parseInt(id);
            chrome.tabs.get(tabId, (tab) => {
                if (chrome.runtime.lastError) {
                    // Tab may be closed, remove from storage
                    chrome.runtime.sendMessage({ action: "STOP", tabId: tabId }, updateActiveTabsList);
                    return;
                }

                const tabDiv = document.createElement("div");
                tabDiv.className = "tab-item";

                const titleSpan = document.createElement("span");
                titleSpan.textContent = tab.title || tab.url;

                const stopBtn = document.createElement("button");
                stopBtn.textContent = "Stop";
                stopBtn.addEventListener("click", () => {
                    chrome.runtime.sendMessage({ action: "STOP", tabId: tabId }, () => {
                        updateActiveTabsList();

                        chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
                            const activeTab = tabs[0];
                            if (activeTab.id === tabId) {
                                document.getElementById("status").textContent = "Stopped.";
                                if (countdownInterval) clearInterval(countdownInterval);
                            }
                        });
                    });
                });

                tabDiv.appendChild(titleSpan);
                tabDiv.appendChild(stopBtn);
                container.appendChild(tabDiv);
            });
        });
    });
}

// Call on popup load
updateStatus();
updateActiveTabsList();

// Start button
document.getElementById("start-btn").addEventListener("click", () => {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        const tab = tabs[0];

        const interval = parseInt(document.getElementById("interval").value);
        const duration = parseInt(document.getElementById("duration").value);
        const intervalUnit = document.getElementById("interval-unit").value;
        const durationUnit = document.getElementById("duration-unit").value;
        const hardRefresh = document.getElementById("hard-refresh").checked;

        let intervalSeconds = interval;
        let runMinutes = duration;
        if (intervalUnit === "min") intervalSeconds *= 60;
        if (intervalUnit === "hr") intervalSeconds *= 3600;
        if (durationUnit === "hr") runMinutes *= 60;

        const endTime = Date.now() + runMinutes * 60 * 1000;

        // Immediately show starting and start local countdown
        document.getElementById("status").textContent = "Starting...";
        startCountdown(endTime);

        // Send message to background to start timer
        chrome.runtime.sendMessage({
            action: "START",
            tabId: tab.id,
            intervalSeconds,
            runMinutes,
            hardRefresh
        }, () => {
            updateActiveTabsList();
        });
    });
});

// Stop button
document.getElementById("stop-btn").addEventListener("click", () => {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        const tab = tabs[0];

        chrome.runtime.sendMessage({ action: "STOP", tabId: tab.id }, () => {
            document.getElementById("status").textContent = "Stopped.";
            if (countdownInterval) clearInterval(countdownInterval);
            updateActiveTabsList();
        });
    });
});
