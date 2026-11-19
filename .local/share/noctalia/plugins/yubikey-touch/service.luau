local streaming = false

local function onLine(line)
  -- touch.py prints a JSON object while waiting and a bare `false` once touched
  local ok, state = pcall(noctalia.json.decode, line)
  noctalia.state.set("waiting", ok and type(state) == "table" and state.tooltip or false)
end

function update()
  if streaming then
    return
  end
  noctalia.setUpdateInterval(60 * 1000)
  streaming = noctalia.runStream("/usr/bin/python3 '" .. noctalia.pluginDir() .. "/touch.py'", onLine)
end
