M = {}

---@param bufnr? number
function M.enabled(bufnr)
  bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
  local gaf = vim.g.autoformat
  local baf = vim.b[bufnr].autoformat

  -- if the buffer has a local value, use that
  if baf ~= nil then
    return baf
  end

  -- otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

function M.toggle_buf()
  vim.b.autoformat = vim.b.autoformat ~= nil and not vim.b.autoformat or false
  if vim.b.autoformat then
    vim.notify("Autoformat enabled for this buffer", "info", { title = "Formatting" })
  else
    vim.notify("Autoformat disabled for this buffer", "info", { title = "Formatting" })
  end
end

function M.toggle()
  vim.g.autoformat = vim.g.autoformat ~= nil and not vim.g.autoformat or false
  if vim.g.autoformat then
    vim.notify("Autoformat enabled", "info", { title = "Formatting" })
  else
    vim.notify("Autoformat disabled", "info", { title = "Formatting" })
  end
end

return M
