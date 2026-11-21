local POLL_MS = 24 * 60 * 60 * 1000

local checking = false

local function check()
  if checking then
    return
  end
  checking = true
  noctalia.runAsync("{ checkupdates; paru -Qua; } 2>/dev/null | grep -vc '\\[ignored\\]'", function(result)
    checking = false
    noctalia.state.set("count", tonumber(result.stdout:match("%d+")) or 0)
  end)
end

noctalia.state.watch("refresh", check)

function update()
  noctalia.setUpdateInterval(POLL_MS)
  check()
end
