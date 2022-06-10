local M = {}

function M.config()
    local colors = require 'gruvbox.colors'

    local theme =   {
        normal = {
            a = { bg = colors.light4, fg = colors.dark0, gui = 'bold' },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light4 },
        },
        insert = {
            a = { bg = colors.bright_blue, fg = colors.dark0, gui = 'bold' },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light4 },
        },
        visual = {
            a = { bg = colors.bright_yellow, fg = colors.dark0, gui = 'bold' },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light4 },
        },
        replace = {
            a = { bg = colors.bright_green, fg = colors.dark0, gui = 'bold' },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light4 },
        },
        command = {
            a = { bg = colors.bright_red, fg = colors.dark0, gui = 'bold' },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light4 },
        },
        inactive = {
            a = { bg = colors.dark1, fg = colors.light4, gui = 'bold' },
            b = { bg = colors.dark1, fg = colors.light4 },
            c = { bg = colors.dark1, fg = colors.light4 },
        },
    }

    require('lualine').setup {
        options = {
            theme = theme,
            component_separators = '',
            section_separators = { left = '', right = ''},  -- 
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {
                {
                    'filetype',
                    padding = { left = 1, right = 0 },
                    colored = false,
                    icon_only = true,
                },
                {
                    'filename',
                    path = 1,
                    symbols = {
                        modified = ' ',  --   ●
                        readonly = '  ',  --    
                    },
                },
            },
            lualine_c = {
                'branch',
                {
                    'diff',
                    symbols = {
                        added = '洛',  --   洛 
                        modified = '柳',  --   柳ﱢ  綠
                        removed = ' ', --    ﯰ   
                    },
                },
            },
            lualine_x = {
                {
                    'diagnostics',
                    symbols = {
                        error =  ' ',  --     
                        warn = ' ',  --    𥉉
                        info = ' ',  --    
                        hint = ' ',  --     𥉉
                    },
                },
            },
            lualine_y = {},
            lualine_z = {
                {
                    'progress',
                    icon = '',
                }
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {'filename'},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        extensions = {}
    }
end

return M
