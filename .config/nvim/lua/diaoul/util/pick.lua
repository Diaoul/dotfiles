local M = {}

M.files = function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.uv.cwd()
  if
    vim.uv.fs_stat(cwd .. "/.git")
    and not vim.uv.fs_stat(cwd .. "/.ignore")
    and not vim.uv.fs_stat(cwd .. "/.rgignore")
  then
    opts.show_untracked = true
    require("telescope.builtin").git_files(opts)
  else
    require("telescope.builtin").find_files(opts)
  end
end

function M.config_files()
  return M.files({ cwd = vim.fn.stdpath("config") })
end

return M
