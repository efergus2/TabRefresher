let activeTimers = {};

// Save timers to storage
function saveTimers() {
    const copy = {};
    for (const tabId in activeTimers) {
        if (!activeTimers.hasOwnProperty(tabId)) continue;
        const t = activeTimers[tabId];
        copy[tabId] = {
            endTime: t.endTime,
            intervalSeconds: t.intervalSeconds,
            hardRefresh: t.hardRefresh
        };
    }
    chrome.storage.local.set({ activeTimers: copy });
}

chrome.runtime.onMessage.addListener((msg, sender) => {
    const { action, tabId } = msg;

    if (action === "START") {
        const { intervalSeconds, runMinutes, hardRefresh } = msg;

        if (activeTimers[tabId]) clearInterval(activeTimers[tabId].interval);

        const endTime = Date.now() + runMinutes * 60 * 1000;

        const intervalId = setInterval(() => {
            if (Date.now() > endTime) {
                clearInterval(intervalId);
                delete activeTimers[tabId];
                saveTimers();
                return;
            }

            if (hardRefresh) chrome.tabs.reload(tabId, { bypassCache: true });
            else chrome.tabs.reload(tabId);
        }, intervalSeconds * 1000);

        activeTimers[tabId] = {
            interval: intervalId,
            endTime,
            intervalSeconds,
            hardRefresh
        };

        saveTimers();
    }

    if (action === "STOP") {
        if (activeTimers[tabId]) {
            clearInterval(activeTimers[tabId].interval);
            delete activeTimers[tabId];
            saveTimers();
        }
    }
});

// On extension load, restore timers from storage
chrome.runtime.onStartup.addListener(() => {
    chrome.storage.local.get("activeTimers", (data) => {
        const stored = data.activeTimers || {};
        for (const tabId in stored) {
            if (!stored.hasOwnProperty(tabId)) continue;
            const t = stored[tabId];
            const intervalId = setInterval(() => {
                if (Date.now() > t.endTime) {
                    clearInterval(intervalId);
                    delete activeTimers[tabId];
                    saveTimers();
                    return;
                }
                if (t.hardRefresh) chrome.tabs.reload(parseInt(tabId), { bypassCache: true });
                else chrome.tabs.reload(parseInt(tabId));
            }, t.intervalSeconds * 1000);

            activeTimers[tabId] = {
                interval: intervalId,
                endTime: t.endTime,
                intervalSeconds: t.intervalSeconds,
                hardRefresh: t.hardRefresh
            };
        }
    });
});
