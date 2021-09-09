local M = {}

M.config = function()
    vim.lsp.protocol.CompletionItemKind = {
        'ﮜ [text]',
        ' [method]',
        ' [function]',
        ' [constructor]',
        'ﰠ [field]',
        ' [variable]',
        ' [class]',
        ' [interface]',
        ' [module]',
        ' [property]',
        ' [unit]',
        ' [value]',
        ' [enum]',
        ' [key]',
        ' [snippet]',
        ' [color]',
        ' [file]',
        ' [reference]',
        ' [folder]',
        ' [enum member]',
        ' [constant]',
        ' [struct]',
        '⌘ [event]',
        ' [operator]',
        '⌂ [type]',
    }

    require('compe').setup {
        source = {
            --- built-in
            path = true;
            buffer = true;
            calc = true;
            spell = true;
            tags = false;
            -- neovim
            nvim_lsp = true;
            nvim_lua = true;
            -- external
            luasnip = true;
            -- treesitter = true;
            -- tabnine = true;
            -- vsnip = true;
            -- tmux = true;
        };
    }

    -- completion with tab
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return true
        else
            return false
        end
    end

    local luasnip = require('luasnip')

    _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t '<C-n>'
        elseif luasnip.expand_or_jumpable() then
            return t '<Plug>luasnip-expand-or-jump'
        elseif check_back_space() then
            return t '<Tab>'
        else
            return vim.fn['compe#complete']()
        end
    end
    _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t '<C-p>'
        elseif luasnip.jumpable(-1) then
            return t '<Plug>luasnip-jump-prev'
        else
            return t '<S-Tab>'
        end
    end
    _G.enter_complete = function()
        if luasnip.choice_active() then
            return t '<Plug>luasnip-next-choice'
        end
        return vim.fn['compe#confirm'](t '<CR>')
    end

    local opts = { silent = true, expr = true }
    vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', opts)
    vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', opts)
    vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', opts)
    vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', opts)
    vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.enter_complete()', opts)
    vim.api.nvim_set_keymap('s', '<CR>', '<cmd>lua require("luasnip").expand_or_jumpable()<CR>', opts)
    vim.api.nvim_set_keymap('i', '<C-Space>', [[compe#complete()]], opts)
    vim.api.nvim_set_keymap('i', '<C-e>', [[compe#close('<C-e>')]], opts)
    -- vim.api.nvim_set_keymap('i', '<CR>', [[compe#confirm('<CR>')]], opts)
end

return M
