local M = {}

function M.setup()
    local function map(...) vim.api.nvim_set_keymap(...) end
    local opts = { noremap = true, silent = true }
    map('n', '<C-e>', '<cmd>lua require("nvim-tree").toggle()<cr>', opts)
end

function M.config()
    -- vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
    vim.g.nvim_tree_indent_markers = 1
    -- vim.g.nvim_tree_show_icons = {
    --     git = 1,
    --     folders = 1,
    --     files = 1,
    --     folder_arrows = 0,
    -- }
    -- vim.g.nvim_tree_icons = {
    --     default = '',
    --     symlink = '',
    --     git_icons = {
    --         unstaged = '✗',
    --         staged = '✓',
    --         unmerged = '',
    --         renamed = '➜',
    --         untracked = '★',
    --         deleted = '',
    --         ignored = '◌',
    --     },
    --     folder_icons = {
    --         arrow_closed = '',
    --         arrow_open = '',
    --         default = '',
    --         open = '',
    --         empty = '',
    --         empty_open = '',
    --         symlink = '',
    --         symlink_open = '',
    --     },
    -- }
    require'nvim-tree'.setup {
        -- disable_netrw        = true,
        -- hijack_netrw         = true,
        -- open_on_setup        = false,
        -- ignore_ft_on_setup   = {},
        -- auto_close           = false,
        -- auto_reload_on_write = true,
        -- open_on_tab          = false,
        -- hijack_cursor        = false,
        -- update_cwd           = false,
        -- hijack_directories   = {
        --   enable = true,
        --   auto_open = true,
        -- },
        diagnostics = {
            enable = true,
            icons = {
                error = " ",  --   ◉
                warn = " ",   --    ●  𥉉
                info = " ",   --   •  
                hint = " ",   --       𥉉
            }
        },
        -- update_focused_file = {
        --     enable      = false,
        --     update_cwd  = false,
        --     ignore_list = {}
        -- },
        -- system_open = {
        --     cmd  = nil,
        --     args = {}
        -- },
        -- filters = {
        --     dotfiles = false,
        --     custom = {}
        -- },
        -- git = {
        --     enable = true,
        --     ignore = true,
        --     timeout = 500,
        -- },
        -- view = {
        --     width = 30,
        --     height = 30,
        --     hide_root_folder = false,
        --     side = 'left',
        --     auto_resize = false,
        --     mappings = {
        --         custom_only = false,
        --         list = {
        --             { key = "K", action = "first_sibling" },
        --             { key = "J", action = "last_sibling" },
        --             { key = "I", action = "toggle_ignored" },
        --             { key = "H", action = "toggle_dotfiles" },
        --         }
        --     },
        --     number = false,
        --     relativenumber = false,
        --     signcolumn = "yes"
        -- },
        -- trash = {
        --     cmd = "trash",
        --     require_confirm = true
        -- },
        -- actions = {
        --     change_dir = {
        --         global = false,
        --     },
        --     open_file = {
        --         quit_on_open = false,
        --     }
        -- }
    }
    -- local colors = require('gruvbox.colors')

    -- vim.api.nvim_set_hl(0, 'NvimTreeFolderName', {fg = colors.bright_blue})
    -- vim.highlight.link('NvimTreeFolderName', 'GruvboxBlue', true)
    -- vim.highlight.link('NvimTreeFolderIcon', 'GruvboxBlue', true)
    -- vim.highlight.link('NvimTreeEmptyFolderName', 'GruvboxBlue', true)
    -- vim.highlight.link('NvimTreeOpenedFolderName', 'GruvboxBlue', true)
    -- vim.cmd('highlight link NvimTreeFolderName GruvboxBlue')
    -- vim.cmd('highlight link NvimTreeFolderIcon GruvboxBlue')
    -- vim.cmd('highlight link NvimTreeEmptyFolderName GruvboxBlue')
    -- vim.cmd('highlight link NvimTreeOpenedFolderName GruvboxBlue')
end

return M
