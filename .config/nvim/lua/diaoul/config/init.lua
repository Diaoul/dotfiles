local M = {}

M.icons = {
  dots = "󰇘",
  indent = "│", -- see :help ibl.config.indent for a list of alternatives
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostic_prefix = "●", -- ■ ● ▎x
  diagnostics = {
    error = " ", --     
    warn = " ", --    𥉉
    info = " ", --    
    hint = " ", --     𥉉
  },
  file = {
    modified = "●", --   ●
    readonly = "", --    
  },
  git = {
    added = " ", --    洛 
    modified = " ", --    柳ﱢ  綠
    removed = " ", --    ﯰ   
  },
  git_signs = {
    add = "▍",
    change = "▍",
    delete = "▍",
    topdelete = "‾",
    changedelete = "▍",
    untracked = "▍",
  },
  tree = {
    collapsed = "", --    ▸
    expanded = "", --    ▾ 
  },
  kinds = {
    -- standard ones
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
    -- extras
    Copilot = "",
  },
}

return M
