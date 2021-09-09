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

    -- current context
    -- see https://github.com/lukas-reineke/indent-blankline.nvim/issues/130
    -- vim.g.indent_blankline_show_current_context = true
    -- vim.opt.colorcolumn = '99999'
    -- vim.g.indent_blankline_context_patterns =
    --     {
    --         'class', 'function', 'method', '^if', '^while', '^for', '^object',
    --         '^table', 'block', 'arguments'
    --     }
end

return M
