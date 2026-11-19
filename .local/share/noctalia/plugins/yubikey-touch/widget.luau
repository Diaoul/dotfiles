local function render(waiting)
  if waiting then
    barWidget.setTooltip(waiting)
  end
  barWidget.setVisible(waiting ~= nil and waiting ~= false)
end

noctalia.state.watch("waiting", render)

function update()
  noctalia.setUpdateInterval(60 * 1000)
  barWidget.setGlyph("key")
  render(noctalia.state.get("waiting"))
end
