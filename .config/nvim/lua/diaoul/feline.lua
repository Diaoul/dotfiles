local M = {}

function M.config()
    local lazy_require = require('feline.utils').lazy_require
    local feline_lsp = lazy_require 'feline.providers.lsp'
    local lsp_severity = vim.diagnostic.severity
    local fn = vim.fn

    local colors = {
        bg = '#3c3836',  -- bg1
        bg0 = '#282828',
        bg0_h = '#1d2021',
        bg0_s = '#32302f',
        bg1 = '#3c3836',
        bg2 = '#504945',
        bg3 = '#665c54',
        bg4 = '#7c6f64',
        fg = '#ebdbb2',  -- fg1
        fg0 = '#fbf1c7',
        fg1 = '#ebdbb2',
        fg2 = '#d5c4a1',
        fg3 = '#bdae93',
        fg4 = '#a89984',
        gray = '#928374',
        bg_red = '#cc241d',
        bg_green = '#98971a',
        bg_yellow = '#d79921',
        bg_blue = '#458588',
        bg_purple = '#b16286',
        bg_aqua = '#689d6a',
        bg_orange = '#d65d0e',
        red = '#fb4934',
        green = '#b8bb26',
        yellow = '#fabd2f',
        blue = '#83a598',
        purple = '#d3869b',
        aqua = '#8ec07c',
        orange = '#fe8019',
    }

    local vi_mode_alias = {
        ['n'] = 'NORMAL',
        ['no'] = 'OP',
        ['i'] = 'INSERT',
        ['ic'] = 'INSERT',
        ['v'] = 'VISUAL',
        ['V'] = 'V-LINE',
        [''] = 'V-BLOCK',
        ['s'] = 'SELECT',
        ['S'] = 'S-LINE',
        [''] = 'S-BLOCK',
        ['R'] = 'REPLACE',
        ['Rv'] = 'V-REPLACE',
        ['c'] = 'COMMAND',
        ['cv'] = 'COMMAND',
        ['ce'] = 'COMMAND',
        ['r'] = 'ENTER',
        ['rm'] = 'MORE',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        ['t'] = 'TERM',
    }

    local vi_mode_colors = {
        ['NORMAL'] = 'gray',
        ['OP'] = 'green',
        ['INSERT'] = 'blue',
        ['VISUAL'] = 'orange',
        ['V-LINE'] = 'orange',
        ['V-BLOCK'] = 'orange',
        ['SELECT'] = 'orange',
        ['S-LINE'] = 'orange',
        ['S-BLOCK'] = 'orange',
        ['REPLACE'] = 'green',
        ['V-REPLACE'] = 'green',
        ['ENTER'] = 'red',
        ['MORE'] = 'red',
        ['COMMAND'] = 'red',
        ['SHELL'] = 'red',
        ['TERM'] = 'red',
    }

    -- Components {{{1
    local components = {}

    components.vi_mode = {
        provider = function ()
            return vi_mode_alias[fn.mode()]
        end,
        short_provider = function ()
            return vi_mode_alias[fn.mode()]:sub(1, 1)
        end,
        priority = 2,
        hl = function()
            return {
                fg = 'bg',
                bg = vi_mode_colors[vi_mode_alias[fn.mode()]],
                style = 'bold'
            }
        end,
        left_sep = {
            str = ' ',
            hl = function ()
                return {
                    fg = 'bg',
                    bg = vi_mode_colors[vi_mode_alias[fn.mode()]],
                }
            end
        },
        right_sep = {
            {
                str = ' ',
                hl = function ()
                    return {
                        -- fg = 'bg3',
                        bg = vi_mode_colors[vi_mode_alias[fn.mode()]],
                    }
                end
            },
            {
                str = 'slant_left',
                hl = function ()
                    return {
                        fg = 'bg2',
                        bg = vi_mode_colors[vi_mode_alias[fn.mode()]],
                    }
                end
            },
        },
    }

    components.file_name = {
        provider = {
            name = 'file_info',
            opts = {
                type = 'relative',
                file_modified_icon = '',  --   ●
                file_readonly_icon = '  ',  --    
                colored_icon = false,
            },
        },
        short_provider = {
            name = 'file_info',
            opts = {
                type = 'base-only',
                file_modified_icon = '',  --   ●
                file_readonly_icon = '  ',  --    
                colored_icon = false,
            },
        },
        priority = 1,
        hl = {
            fg = 'fg2',
            bg = 'bg2',
        },
        left_sep = {
            str = ' ',
            hl = {
                bg = 'bg2',
            },
        },
        right_sep = {
            {
                str = ' ',
                hl = {
                    bg = 'bg2',
                },
            },
            {
                str = 'slant_left',
                hl = {
                    fg = 'bg1',
                    bg = 'bg2',
                },
            },
        },
    }

    components.git_branch = {
        provider = 'git_branch',
        truncate_hide = true,
        hl = {
            fg = 'fg3',
            bg = 'bg1',
        },
        left_sep = ' ',
    }

    components.git_diff = {
        add = {
            provider = 'git_diff_added',
            hl = {
                fg = 'green',
                -- fg = 'fg3',
            },
            icon = '洛',  --   洛 
            -- icon = ' ',
            left_sep = ' ',
        },

        change = {
            provider = 'git_diff_changed',
            hl = {
                fg = 'aqua',
                -- fg = 'fg3',
            },
            icon = '柳',  --   柳ﱢ  綠
            -- icon = ' ',
            left_sep = ' ',
        },

        remove = {
            provider = 'git_diff_removed',
            hl = {
                fg = 'red',
                -- fg = 'fg3',
            },
            icon = ' ', --    ﯰ   
            -- icon = ' ',
            left_sep = ' ',
        },
    }

    components.diagnostic = {
        errors = {
            provider = 'diagnostic_errors',
            enabled = function()
                return feline_lsp.diagnostics_exist(lsp_severity.ERROR)
            end,

            hl = {
                fg = 'red',
                bg = 'bg1',
            },
            icon = '  ',  --     
        },

        warning = {
            provider = 'diagnostic_warnings',
            enabled = function()
                return feline_lsp.diagnostics_exist(lsp_severity.WARN)
            end,
            hl = {
                fg = 'yellow',
                bg = 'bg1',
            },
            icon = '  ',  --    𥉉
        },

        info = {
            provider = 'diagnostic_info',
            enabled = function()
                return feline_lsp.diagnostics_exist(lsp_severity.INFO)
            end,
            hl = {
                fg = 'blue',
                bg = 'bg1',
            },
            icon = '  ',  --    
        },

        hint = {
            provider = 'diagnostic_hints',
            enabled = function()
                return feline_lsp.diagnostics_exist(lsp_severity.HINT)
            end,
            hl = {
                fg = 'aqua',
                bg = 'bg1',
            },
            icon = '  ',  --     𥉉
        },
    }

    components.lsp_attached = {
        provider = 'LSP',
        enabled = feline_lsp.is_lsp_attached,
        truncate_hide = true,
        hl = {
            fg = 'fg3',
            bg = 'bg1',
        },
        left_sep = ' ',
        right_sep = ' ',
        icon = '  ',
    }

    components.lsp_client_names = {
        provider = 'lsp_client_names',
        truncate_hide = true,
        hl = {
            fg = 'fg3',
            bg = 'bg1',
        },
        left_sep = ' ',
        right_sep = ' ',
        icon = '  ',
    }

    components.position = {
        provider = 'position',
        hl = {
            fg = 'fg2',
            bg = 'bg2',
        },
        left_sep = {
            {
                str = 'slant_left',
                hl = {
                    fg = 'bg2',
                },
            },
        },
        right_sep = {
            str = ' ',
            hl = {
                bg = 'bg2',
            },
        },
        icon = '  ',
    }

    components.line_percentage = {
        provider = 'line_percentage',
        hl = {
            fg = 'bg',
            bg = 'gray',
        },
        left_sep = {
            {
                str = 'slant_left',
                hl = {
                    fg = 'gray',
                },
            },
        },
        right_sep = {
            str = ' ',
            hl = {
                bg = 'gray',
            },
        },
        icon = '  ',
    }

    components.line_percentage_colored = {
        provider = 'line_percentage',
        hl = function()
            return {
                fg = 'bg',
                bg = vi_mode_colors[vi_mode_alias[fn.mode()]],
                style = 'bold'
            }
        end,
        left_sep = {
            {
                str = 'slant_left',
                hl = function ()
                    return {
                        fg = vi_mode_colors[vi_mode_alias[fn.mode()]],
                        bg = 'bg',
                    }
                end,
            },
        },
        right_sep = {
            str = ' ',
            hl = function ()
                return {
                    bg = vi_mode_colors[vi_mode_alias[fn.mode()]],
                }
            end,
        },
        icon = '  ',
   }

    -- }}}1

    require('feline').setup {
        theme = colors,
        vi_mode_colors = vi_mode_colors,
        components = {
            active = {
                {
                    components.vi_mode,
                    components.file_name,
                    components.git_branch,
                    components.git_diff.add,
                    components.git_diff.change,
                    components.git_diff.remove,
                },
                {
                    components.diagnostic.errors,
                    components.diagnostic.warning,
                    components.diagnostic.hint,
                    components.diagnostic.info,
                    -- components.lsp_attached,
                    components.lsp_client_names,
                    -- components.position,
                    -- components.line_percentage,
                    components.line_percentage_colored,
                }
            },
            inactive = {
                {
                    components.file_name,
                    ' ',  -- to apply bg to the rest of the bar
                },
            },
        },
    }
end

return M
