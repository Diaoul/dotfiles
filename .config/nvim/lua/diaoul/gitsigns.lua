local M = {}

function M.config()
    require('gitsigns').setup {
        signs = {
            add = {
                hl = 'GitSignsAdd',
                text = '▍',
                numhl = 'GitSignsAddNr',
                linehl = 'GitSignsAddLn',
            },
            change = {
                hl = 'GitSignsChange',
                text = '▍',
                numhl = 'GitSignsChangeNr',
                linehl = 'GitSignsChangeLn',
            },
            delete = {
                hl = 'GitSignsDelete',
                text = '▍',
                show_count = true,
                numhl = 'GitSignsDeleteNr',
                linehl = 'GitSignsDeleteLn',
            },
            topdelete = {
                hl = 'GitSignsDelete',
                text = '‾',
                show_count = true,
                numhl = 'GitSignsDeleteNr',
                linehl = 'GitSignsDeleteLn',
            },
            changedelete = {
                hl = 'GitSignsChange',
                text = '▍',
                show_count = true,
                numhl = 'GitSignsChangeNr',
                linehl = 'GitSignsChangeLn',
            },
        },
        count_chars = {
            [1] = '₁',
            [2] = '₂',
            [3] = '₃',
            [4] = '₄',
            [5] = '₅',
            [6] = '₆',
            [7] = '₇',
            [8] = '₈',
            [9] = '₉',
            ['+'] = '₊',
        },
        preview_config = {
            border = 'none',
        },
        -- neovim 0.6
        keymaps = {
            -- default keymap options
            noremap = true,

            -- navigation
            ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'"},
            ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'"},

            -- actions
            ['n <leader>hs'] = '<cmd>Gitsigns stage_hunk<CR>',
            ['v <leader>hs'] = ':Gitsigns stage_hunk<CR>',
            ['n <leader>hu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
            ['n <leader>hr'] = '<cmd>Gitsigns reset_hunk<CR>',
            ['v <leader>hr'] = ':Gitsigns reset_hunk<CR>',
            ['n <leader>hR'] = '<cmd>Gitsigns reset_buffer<CR>',
            ['n <leader>hp'] = '<cmd>Gitsigns preview_hunk<CR>',
            ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
            ['n <leader>tb'] = '<cmd>Gitsigns toggle_current_line_blame<CR>',
            ['n <leader>hS'] = '<cmd>Gitsigns stage_buffer<CR>',
            ['n <leader>hU'] = '<cmd>Gitsigns reset_buffer_index<CR>',
            ['n <leader>td'] = '<cmd>Gitsigns toggle_deleted<CR>',

            -- text objects
            ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
            ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
        },
        -- neovim 0.7+
        -- on_attach = function(bufnr)
        --     local gs = package.loaded.gitsigns

        --     local function map(mode, l, r, opts)
        --         opts = opts or {}
        --         opts.buffer = bufnr
        --         vim.keymap.set(mode, l, r, opts)
        --     end

        --     -- navigation
        --     map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
        --     map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

        --     -- actions
        --     map({'n', 'v'}, '<leader>hs', gs.stage_hunk)
        --     map({'n', 'v'}, '<leader>hr', gs.reset_hunk)
        --     map('n', '<leader>hS', gs.stage_buffer)
        --     map('n', '<leader>hu', gs.undo_stage_hunk)
        --     map('n', '<leader>hR', gs.reset_buffer)
        --     map('n', '<leader>hp', gs.preview_hunk)
        --     map('n', '<leader>hb', function() gs.blame_line{full=true} end)
        --     map('n', '<leader>tb', gs.toggle_current_line_blame)
        --     map('n', '<leader>hd', gs.diffthis)
        --     map('n', '<leader>hD', function() gs.diffthis('~') end)
        --     map('n', '<leader>td', gs.toggle_deleted)

        --     -- text object
        --     map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        -- end,
    }
end

return M
