-- based off LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
local function augroup(name)
  return vim.api.nvim_create_augroup("diaoul_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns-blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Quit buffer" })
  end,
})

-- Make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- qmk.nvim dynamic configurations
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("qmk_corne"),
  pattern = "*/corne/*/keymap.c",
  callback = function()
    require("qmk").setup({
      name = "LAYOUT_split_3x6_3",
      auto_format_pattern = "*/corne/*/keymap.c",
      comment_preview = {
        position = "none",
      },
      layout = {
        "x x x x x x _ _ _ x x x x x x",
        "x x x x x x _ _ _ x x x x x x",
        "x x x x x x _ _ _ x x x x x x",
        "_ _ _ _ x x x _ x x x _ _ _ _",
      },
    })
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("qmk_skeletyl"),
  pattern = "*/skeletyl/*/keymap.c",
  callback = function()
    require("qmk").setup({
      name = "LAYOUT_split_3x5_3",
      auto_format_pattern = "*/skeletyl/*/keymap.c",
      comment_preview = {
        position = "none",
      },
      layout = {
        "x x x x x _ _ _ x x x x x",
        "x x x x x _ _ _ x x x x x",
        "x x x x x _ _ _ x x x x x",
        "_ _ _ x x x _ x x x _ _ _",
      },
    })
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("qmk_kyria"),
  pattern = "*/kyria/*/keymap.c",
  callback = function()
    require("qmk").setup({
      name = "LAYOUT_split_3x6_5",
      auto_format_pattern = "*/kyria/*/keymap.c",
      comment_preview = {
        position = "none",
      },
      layout = {
        "x x x x x x _ _ _ _ _ x x x x x x",
        "x x x x x x _ _ _ _ _ x x x x x x",
        "x x x x x x x x _ x x x x x x x x",
        "_ _ _ x x x x x _ x x x x x _ _ _",
      },
    })
  end,
})
