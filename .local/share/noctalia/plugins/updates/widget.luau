local function render(count)
  if count == nil then
    return
  end
  barWidget.setText(tostring(count))
  barWidget.setTooltip(count == 1 and "1 update available" or count .. " updates available")
end

noctalia.state.watch("count", render)

function update()
  noctalia.setUpdateInterval(60 * 1000)
  barWidget.setGlyph("package")
  render(noctalia.state.get("count"))
end

function onClick()
  noctalia.runAsync("ghostty -e paru -Syu", function()
    noctalia.state.set("refresh", os.time())
  end)
end

function onRightClick()
  noctalia.state.set("refresh", os.time())
end
