local M = {}

function M.project_files(...)
    local git_files = pcall(require'telescope.builtin'.git_files, ...)
    if not git_files then
        require'telescope.builtin'.find_files(...)
    end
end

function M.setup()
    -- mappings
    local function map(...) vim.api.nvim_set_keymap(...) end
    local opts = { noremap = true, silent = true }

    map('n', '<leader>ff', '<cmd>lua require("diaoul.telescope").project_files()<cr>', opts)
    map('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)
    map('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
    map('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', opts)
end

function M.config()
    local actions = require 'telescope.actions'

    require('telescope').setup {
        defaults = {
            prompt_prefix = ' ❯ ',
            mappings = {
                i = {
                    ['<Esc>'] = actions.close,
                    ['<C-j>'] = actions.move_selection_next,
                    ['<C-k>'] = actions.move_selection_previous,
                },
            },
        },
    }
end

return M
