require('telescope').setup { }

local function set_keymap(...) vim.api.nvim_set_keymap(...) end
local opts = { noremap = true, silent = true }

set_keymap('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], opts)
set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], opts)
set_keymap('n', '<leader>l', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], opts)
set_keymap('n', '<leader>t', [[<cmd>lua require('telescope.builtin').tags()<cr>]], opts)
set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]], opts)
set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], opts)
set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], opts)
set_keymap('n', '<leader>o', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<cr>]], opts)
set_keymap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').git_commits()<cr>]], opts)
set_keymap('n', '<leader>gb', [[<cmd>lua require('telescope.builtin').git_branches()<cr>]], opts)
set_keymap('n', '<leader>gs', [[<cmd>lua require('telescope.builtin').git_status()<cr>]], opts)
set_keymap('n', '<leader>gp', [[<cmd>lua require('telescope.builtin').git_bcommits()<cr>]], opts)
