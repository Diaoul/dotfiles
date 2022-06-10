local M = {}

function M.setup()
    vim.keymap.set('n', '<C-e>', function()
        require('nvim-tree').toggle()
    end)
end

function M.config()
    require'nvim-tree'.setup {
        view = {
            hide_root_folder = true,
            mappings = {
                custom_only = true,
                list = {
                    { key = {"<CR>", "<2-LeftMouse>"}, action = "edit" },
                    { key = "+", action = "cd" },
                    { key = "<C-v>", action = "vsplit" },
                    { key = "<C-x>", action = "split" },
                    { key = "<C-t>", action = "tabnew" },
                    { key = "B", action = "prev_sibling" },
                    { key = "b", action = "next_sibling" },
                    { key = "p", action = "parent_node" },
                    { key = "<BS>", action = "close_node" },
                    { key = "<Tab>", action = "preview" },
                    { key = "<S-Up>", action = "first_sibling" },
                    { key = "<S-Down>", action = "last_sibling" },
                    { key = "!", action = "toggle_git_ignored" },
                    { key = ".", action = "toggle_dotfiles" },
                    { key = "R", action = "refresh" },
                    { key = "a", action = "create" },
                    { key = {"<BS>", "D"}, action = "remove" },
                    { key = "cw", action = "rename" },
                    { key = "cW", action = "full_rename" },
                    { key = "dd", action = "cut" },
                    { key = "yy", action = "copy" },
                    { key = "p", action = "paste" },
                    { key = "yn", action = "copy_name" },
                    { key = "yp", action = "copy_path" },
                    { key = "yP", action = "copy_absolute_path" },
                    { key = "[c", action = "prev_git_item" },
                    { key = "]c", action = "next_git_item" },
                    { key = "-", action = "dir_up" },
                    { key = "s", action = "system_open" },
                    { key = "q", action = "close" },
                    { key = "g?", action = "toggle_help" },
                    { key = "zc", action = "collapse_all" },
                    { key = "<C-k>", action = "toggle_file_info" },
                },
            },
        },
        diagnostics = {
            enable = true,
            icons = {
                error = " ",  --   ◉
                warning = " ",   --    ●  𥉉
                info = " ",   --   •  
                hint = " ",   --       𥉉
            }
        },
        renderer = {
            indent_markers = {
                enable = true,
            },
            icons = {
                webdev_colors = false,
                glyphs = {
                    default = "",
                    symlink = "",
                    folder = {
                        arrow_open = "",
                        arrow_closed = "",
                        default = "",  --  
                        open = "",  --  
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌"
                    },
                },
            },
        },
        update_focused_file = {
            enable = true,
        },
    }
    local colors = require('gruvbox.colors')

    vim.api.nvim_set_hl(0, 'NvimTreeRootFolder', {fg = colors.neutral_purple, bold = true})
    vim.api.nvim_set_hl(0, 'NvimTreeIndentMarker', {fg = colors.dark3})
    vim.api.nvim_set_hl(0, 'NvimTreeFolderName', {fg = colors.neutral_blue, bold = true})
    vim.api.nvim_set_hl(0, 'NvimTreeFolderIcon', {fg = colors.neutral_blue})
    vim.api.nvim_set_hl(0, 'NvimTreeEmptyFolderName', {fg = colors.neutral_blue, bold = true})
    vim.api.nvim_set_hl(0, 'NvimTreeOpenedFolderName', {fg = colors.neutral_blue, bold = true})
    vim.api.nvim_set_hl(0, 'NvimTreeFileIcon', {fg = colors.light2})
    vim.api.nvim_set_hl(0, 'NvimTreeOpenedFile', {fg = colors.bright_red, bold = true})
    vim.api.nvim_set_hl(0, 'NvimTreeExecFile', {fg = colors.neutral_green})
    vim.api.nvim_set_hl(0, 'NvimTreeImageFile', {fg = colors.neutral_purple})
    vim.api.nvim_set_hl(0, 'NvimTreeSpecialFile', {fg = colors.neutral_yellow, bold = true, underline = true})
    vim.api.nvim_set_hl(0, 'NvimTreeSymlink', {fg = colors.neutral_aqua})
    vim.api.nvim_set_hl(0, 'NvimTreeGitDirty', {fg = colors.neutral_yellow})
    vim.api.nvim_set_hl(0, 'NvimTreeGitDeleted', {fg = colors.neutral_red})
    vim.api.nvim_set_hl(0, 'NvimTreeGitStaged', {fg = colors.neutral_yellow})
    vim.api.nvim_set_hl(0, 'NvimTreeGitMerge', {fg = colors.neutral_purple})
    vim.api.nvim_set_hl(0, 'NvimTreeGitRenamed', {fg = colors.neutral_purple})
    vim.api.nvim_set_hl(0, 'NvimTreeGitNew', {fg = colors.neutral_yellow})
    vim.api.nvim_set_hl(0, 'NvimTreeWindowPicker', {bg = colors.neutral_blue})

    vim.cmd [[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]
end

return M
