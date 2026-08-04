-- make sure hammerspoon starts at login (monitor watcher below)
hs.autoLaunch(true)

-- Debounce timer to prevent rapid repeated executions
local debounceTimer = nil
local debounceDelay = 2  -- seconds

-- Debounced function to run the workspace script
local function runWorkspaceScript()
    if debounceTimer then
        debounceTimer:stop()
    end

    debounceTimer = hs.timer.doAfter(debounceDelay, function()
        hs.execute("~/.config/aerospace/scripts/workspaces.sh && sketchybar --reload")
    end)
end

-- Run workspace script on display configuration change
displayWatcher = hs.screen.watcher.new(function()
    runWorkspaceScript()
end)
displayWatcher:start()

-- Run workspace script on wake from sleep
sleepWatcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.systemDidWake then
        runWorkspaceScript()
    end
end)
sleepWatcher:start()

-- Notify that Hammerspoon config has been loaded
hs.notify.new({title="Hammerspoon", informativeText="Configuration loaded"}):send()
