local M = {}

function M.config()
    vim.g.indent_blankline_char = '┊'  -- │ | ¦ ┆ ┊ ▏
    vim.g.indent_blankline_show_trailing_blankline_indent = false
    vim.g.indent_blankline_use_treesitter = true
    vim.g.indent_blankline_filetype_exclude = {
        'help',
        'markdown',
        'txt',
        'gitcommit',
        'packer',
    }
    vim.g.indent_blankline_buftype_exclude = {
        'terminal',
        'nofile',
    }
end

return M
