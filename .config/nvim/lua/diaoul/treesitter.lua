local M = {}

function M.config()
    require('nvim-treesitter.configs').setup {
        ensure_installed = 'maintained',
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<CR>',
                node_incremental = '<CR>',
                scope_incrementexpral = '<TAB>',
                node_decremental = '<BS>',
            },
        },
        refactor = {
            highlight_definitions = { enable = true },
            highlight_current_scope = { enable = false },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = 'grr',
                },
            },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = 'gnd',
                    list_definitions = 'gnD',
                    list_definitions_toc = "gO",
                    goto_next_usage = '<leader>*',
                    goto_previous_usage = '<leader>#',
                },
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["aC"] = "@class.outer",
                    ["iC"] = "@class.inner",
                    ['ac'] = '@conditional.outer',
                    ['ic'] = '@conditional.inner',
                    ['ab'] = '@block.outer',
                    ['ib'] = '@block.inner',
                    ['al'] = '@loop.outer',
                    ['il'] = '@loop.inner',
                    ['is'] = '@statement.inner',
                    ['as'] = '@statement.outer',
                    ['am'] = '@call.outer',
                    ['im'] = '@call.inner',
                    ['ad'] = '@comment.outer',
                    ['id'] = '@comment.inner',
                    ['ap'] = '@parameter.outer',
                    ['ip'] = '@parameter.inner',

                    -- Or you can define your own textobjects like this
                    ["iF"] = {
                        python = "(function_definition) @function",
                        cpp = "(function_definition) @function",
                        c = "(function_definition) @function",
                        java = "(method_declaration) @function",
                    },
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                    ['<leader>f'] = '@function.outer',
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                    ['<leader>F'] = '@function.outer',
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            lsp_interop = {
                enable = true,
                border = 'none',
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dF"] = "@class.outer",
                },
            },
        },
        playground = {
            enable = true,
            updatetime = 25,
            persist_queries = false,
            keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<CR>',
                show_help = '?',
            },
        },
        autopairs = { enable = true },
    }
end

return M
