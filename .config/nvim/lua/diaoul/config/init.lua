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
  diagnostic_prefix = "●", -- ■ ● ▎
  diagnostics = {
    error = " ", -- 
    warn = " ", --   
    info = " ", --   
    hint = " ", --   
  },
  file = {
    modified = "●", --   ●
    readonly = "", -- 
  },
  git = {
    added = " ", --       
    modified = " ", --    
    removed = " ", --     
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
    collapsed = "", --   ▸
    expanded = "", --     ▾
  },
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = "󱄽 ",
    String = " ",
    Struct = "󰆼 ",
    Supermaven = " ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },
}

return M
