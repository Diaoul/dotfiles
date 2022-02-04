-- Run workspace script on display configuration change
displayWatcher = hs.screen.watcher.new(function()
    hs.execute("~/.config/aerospace/scripts/workspaces.sh && sketchybar --reload")
end)
displayWatcher:start()

-- Run workspace script on wake from sleep
sleepWatcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.systemDidWake then
        hs.execute("~/.config/aerospace/scripts/workspaces.sh && sketchybar --reload")
    end
end)
sleepWatcher:start()

-- Notify that Hammerspoon config has been loaded
hs.notify.new({title="Hammerspoon", informativeText="Configuration loaded"}):send()
