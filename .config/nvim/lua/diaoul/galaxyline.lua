local M = {}

M.config = function()
    vim.g.gruvbox_invert_selection = 0
    vim.g.gruvbox_italic = 1
    vim.g.gruvbox_sign_column = 'bg0'

    vim.cmd('set background=dark')
    vim.cmd('colorscheme gruvbox')


    -- Gruvbox dark
    local colors = {
        bg0_h = '#1d2021',
        bg0 = '#282828',
        bg0_s = '#32302f',
        bg1 = '#3c3836',
        bg2 = '#504945',
        bg3 = '#665c54',
        bg4 = '#7c6f64',
        gray = '#928374',
        fg0 = '#fbf1c7',
        fg1 = '#ebdbb2',
        fg2 = '#d5c4a1',
        fg3 = '#bdae93',
        fg4 = '#a89984',
        br_red = '#fb4934',
        br_green = '#b8bb26',
        br_yellow = '#fabd2f',
        br_blue = '#83a598',
        br_purple = '#d3869b',
        br_aqua = '#8ec07c',
        br_orange = '#fe8019',
        red = '#cc241d',
        green = '#98971a',
        yellow = '#d79921',
        blue = '#458588',
        purple = '#b16286',
        aqua = '#689d6a',
        orange = '#d65d0e',
    }
    local function highlight(group, fg, bg)
        local cmd = string.format('highlight %s guifg=%s guibg=%s', group, fg, bg)
        vim.cmd(cmd)
    end

    vim.cmd('highlight StatusLine                                                                                                guifg=#3c3836')

    vim.cmd('highlight GalaxyLeftGitDiffAddActive                                                                  guibg=#3c3836 guifg=#27b31a')
    vim.cmd('highlight GalaxyLeftGitDiffInactive                                                                   guibg=#3c3836 guifg=#ebdbb2')
    vim.cmd('highlight GalaxyLeftGitDiffModifiedActive                                                             guibg=#3c3836 guifg=#fe8019')
    vim.cmd('highlight GalaxyLeftGitDiffRemoveActive                                                               guibg=#3c3836 guifg=#fb4632')
    vim.cmd('highlight GalaxyLeftLspInactive                                                                       guibg=#3c3836 guifg=#d5c4a1')
    vim.cmd('highlight GalaxyMapperCommon1                                                                         guibg=#3c3836 guifg=#504945')
    vim.cmd('highlight GalaxyMapperCommon2                                                                         guibg=#bdae93 guifg=#504945')
    vim.cmd('highlight GalaxyMapperCommon3                                                                         guibg=#3c3836 guifg=#ebdbb2')
    vim.cmd('highlight GalaxyMapperCommon4                                                                         guibg=#504945 guifg=#ebdbb2')
    vim.cmd('highlight GalaxyMapperCommon5                                                                         guibg=#3c3836 guifg=#d5c4a1')
    vim.cmd('highlight GalaxyMapperCommon6                                                                         guibg=#504945 guifg=#d5c4a1')
    vim.cmd('highlight GalaxyMapperCommon7                                                                         guibg=#504945 guifg=#bdae93')
    vim.cmd('highlight GalaxyMapperCommon8                                                                         guibg=#504945 guifg=#91a6ba')
    vim.cmd('highlight GalaxyMidFileStatusModified                                                                 guibg=#3c3836 guifg=#8ec07c')
    vim.cmd('highlight GalaxyMidFileStatusReadonly                                                                 guibg=#3c3836 guifg=#fe8019')
    vim.cmd('highlight GalaxyMidFileStatusRestricted                                                               guibg=#3c3836 guifg=#fb4632')
    vim.cmd('highlight GalaxyMidFileStatusUnmodified                                                               guibg=#3c3836 guifg=#d5c4a1')
    vim.cmd('highlight GalaxyRightLspErrorActive                                                                   guibg=#3c3836 guifg=#fb4632')
    vim.cmd('highlight GalaxyRightLspHintActive                                                                    guibg=#3c3836 guifg=#27b31a')
    vim.cmd('highlight GalaxyRightLspInformationActive                                                             guibg=#3c3836 guifg=#127fff')
    vim.cmd('highlight GalaxyRightLspWarningActive                                                                 guibg=#3c3836 guifg=#fe8019')
    vim.cmd('highlight GalaxyViModeCommandInverted                                                                 guibg=#504945 guifg=#fabd2f')
    vim.cmd('highlight GalaxyViModeCommandUnturned                                                                 guibg=#fabd2f guifg=#3c3836')
    vim.cmd('highlight GalaxyViModeCommonVisualInverted                                                            guibg=#504945 guifg=#fe8019')
    vim.cmd('highlight GalaxyViModeCommonVisualUnturned                                                            guibg=#fe8019 guifg=#3c3836')
    vim.cmd('highlight GalaxyViModeEmptyInverted                                                                   guibg=#504945 guifg=#bdae93')
    vim.cmd('highlight GalaxyViModeEmptyUnturned                                                                   guibg=#bdae93 guifg=#3c3836')
    vim.cmd('highlight GalaxyViModeInsertInverted                                                                  guibg=#504945 guifg=#83a598')
    vim.cmd('highlight GalaxyViModeInsertUnturned                                                                  guibg=#83a598 guifg=#3c3836')
    vim.cmd('highlight GalaxyViModeNormalInverted                                                                  guibg=#504945 guifg=#bdae93')
    vim.cmd('highlight GalaxyViModeNormalUnturned                                                                  guibg=#bdae93 guifg=#3c3836')
    vim.cmd('highlight GalaxyViModeReplaceInverted                                                                 guibg=#504945 guifg=#8ec07c')
    vim.cmd('highlight GalaxyViModeReplaceUnturned                                                                 guibg=#8ec07c guifg=#3c3836')
    vim.cmd('highlight GalaxyViModeShellInverted                                                                   guibg=#504945 guifg=#d3869b')
    vim.cmd('highlight GalaxyViModeShellUnturned                                                                   guibg=#d3869b guifg=#3c3836')
    vim.cmd('highlight GalaxyViModeTerminalInverted                                                                guibg=#504945 guifg=#d3869b')
    vim.cmd('highlight GalaxyViModeTerminalUnturned                                                                guibg=#d3869b guifg=#d5c4a1')

    require ('galaxyline').short_line_list = {
        'Mundo',
        'MundoDiff',
        'NvimTree',
        'fugitive',
        'fugitiveblame',
        'help',
        'minimap',
        'qf',
        'tabman',
        'tagbar',
        'toggleterm'
    }

    local mode_map = {
        ['n']    = {'NORMAL', colors.fg3},
        ['i']    = {'INSERT', colors.br_blue},
        ['R']    = {'REPLACE', colors.br_aqua},
        ['c']    = {'COMMAND', colors.br_yellow},
        ['v']    = {'VISUAL', colors.br_orange},
        ['V']    = {'V-LINE', colors.br_orange},
        ['']   = {'V-BLOCK', colors.br_orange},
        ['t']    = {'TERMINAL', colors.br_aqua},
        -- ['s']  = {'SELECT', colors.br_orange},
        -- ['S']  = {'S-LINE', colors.br_orange},
        -- [''] = {'S-BLOCK', colors.br_orange},
        -- ['Rv'] = {'VIRTUAL'},
        -- ['rm'] = {'--MORE'},
    }

    local function current_mode()
        local mode = mode_map[vim.fn.mode()]
        if mode == nil then
            return {'UNKNOWN ' .. vim.fn.mode(), colors.br_red}
        end
        return mode
    end

    local gl = require('galaxyline')
    local gls = gl.section
    local devicons = require('nvim-web-devicons')
    local condition = require('galaxyline.condition')
    local vcs = require('galaxyline.provider_vcs')

    gls.left = {
        {
            ViMode = {
                highlight = 'GalaxyViMode',
                provider = function()
                    local label, color = unpack(current_mode())
                    highlight('GalaxyViMode', colors.bg1, color)
                    highlight('GalaxyViModeInverted', color, colors.bg2)
                    return '  ' .. label .. ' '
                end,
                separator_highlight = 'GalaxyViModeInverted',
                separator = '',
            }
        },
        {
            FileIcon = {
                highlight = 'GalaxyFileIcon',
                provider = function()
                    if vim.bo.modified then
                        highlight('GalaxyFileIcon', colors.br_yellow, colors.bg2)
                    else
                        highlight('GalaxyFileIcon', colors.fg2, colors.bg2)
                    end
                    -- elseif not vim.bo.modifiable then
                    --   vim.cmd('highlight link GalaxyMidFileStatus GalaxyMidFileStatusRestricted')
                    -- elseif vim.bo.readonly then
                    --   vim.cmd('highlight link GalaxyMidFileStatus GalaxyMidFileStatusReadonly')
                    -- elseif not vim.bo.modified then
                    --   vim.cmd('highlight link GalaxyMidFileStatus GalaxyMidFileStatusUnmodified')
                    -- end

                    icon = devicons.get_icon(vim.fn.expand('%:e'))
                    if icon then
                        return ' ' .. icon .. ' '
                    end
                    return '  '
                end,
            }
        },
        {
            FileName = {
                highlight = {colors.fg2, colors.bg2},
                provider = function()
                    if #vim.fn.expand('%:p') == 0 then
                        return '-'
                    end
                    if vim.fn.winwidth(0) > 150 then
                        return vim.fn.expand('%:~')
                    end
                    return vim.fn.expand('%:t')
                end,
            }
        },
        {
            FilePasteStatus = {
                highlight = {colors.fg2, colors.bg2},
                provider = function()
                    if vim.o.paste then
                        return '   '
                    end
                    return '  '
                end,
                separator = '',
                separator_highlight = {colors.bg2, colors.bg1},
            }
        },
        {
            GitBranch = {
                condition = condition.check_git_workspace,
                highlight = {colors.fg2, colors.bg1},
                provider = vcs.get_git_branch,
                icon = '  ',
            }
        },
        {
            GitDiffAdd = {
                condition = condition.check_git_workspace,
                provider = function()
                    if vcs.diff_add() then
                        vim.cmd('highlight link GalaxyLeftGitDiffAdd GalaxyLeftGitDiffAddActive')
                        return vcs.diff_add()
                    else
                        vim.cmd('highlight link GalaxyLeftGitDiffAdd GalaxyLeftGitDiffInactive')
                        return '0'
                    end
                end,
                icon = '+',
            }
        },
        {
            GitDiffModified= {
                condition = condition.check_git_workspace,
                provider = function()
                    if vcs.diff_modified() then
                        vim.cmd('highlight link GalaxyLeftGitDiffModified GalaxyLeftGitDiffModifiedActive')
                        return vcs.diff_modified()
                    else
                        vim.cmd('highlight link GalaxyLeftGitDiffModified GalaxyLeftGitDiffInactive')
                        return '0'
                    end
                end,
                icon = '~',
            }
        },
        {
            GitDiffRemove = {
                highlight = 'GalaxyGitDiffRemove',
                condition = condition.check_git_workspace,
                provider = function()
                    if vcs.diff_remove() then
                        highlight('GalaxyGitDiffRemove', colors.red, colors.bg1)
                        return '-' .. vcs.diff_remove()
                    end
                    highlight('GalaxyGitDiffRemove', colors.fg1, colors.bg1)
                    return '-0 '
                end,
            }
        },
    }

    gls.mid = {
    }

    gls.right = {
        {
            RightLspError = {
                provider = function()
                    if #vim.tbl_keys(vim.lsp.buf_get_clients()) <= 0 then
                        return
                    end

                    if vim.lsp.diagnostic.get_count(0, 'Error') == 0 then
                        vim.cmd('highlight link GalaxyRightLspError GalaxyLeftLspInactive')
                    else
                        vim.cmd('highlight link GalaxyRightLspError GalaxyRightLspErrorActive')
                    end

                    return '!' .. vim.lsp.diagnostic.get_count(0, 'Error') .. ' '
                end
            }
        },
        {
            RightLspWarning = {
                provider = function()
                    if #vim.tbl_keys(vim.lsp.buf_get_clients()) <= 0 then
                        return
                    end

                    if vim.lsp.diagnostic.get_count(0, 'Warning') == 0 then
                        vim.cmd('highlight link GalaxyRightLspWarning GalaxyLeftLspInactive')
                    else
                        vim.cmd('highlight link GalaxyRightLspWarning GalaxyRightLspWarningActive')
                    end

                    return '?' .. vim.lsp.diagnostic.get_count(0, 'Warning') .. ' '
                end
            }
        },
        {
            RightLspInformation = {
                provider = function()
                    if #vim.tbl_keys(vim.lsp.buf_get_clients()) <= 0 then
                        return
                    end

                    if vim.lsp.diagnostic.get_count(0, 'Information') == 0 then
                        vim.cmd('highlight link GalaxyRightLspInformation GalaxyLeftLspInactive')
                    else
                        vim.cmd('highlight link GalaxyRightLspInformation GalaxyRightLspInformationActive')
                    end

                    return '+' .. vim.lsp.diagnostic.get_count(0, 'Information') .. ' '
                end
            }
        },
        {
            RightLspHint = {
                provider = function()
                    if #vim.tbl_keys(vim.lsp.buf_get_clients()) <= 0 then
                        return
                    end

                    if vim.lsp.diagnostic.get_count(0, 'Hint') == 0 then
                        vim.cmd('highlight link GalaxyRightLspHint GalaxyLeftLspInactive')
                    else
                        vim.cmd('highlight link GalaxyRightLspHint GalaxyRightLspHintActive')
                    end

                    return '-' .. vim.lsp.diagnostic.get_count(0, 'Hint') .. ' '
                end
            }
        },
        {
            RightLspHintSeparator = {
                highlight = 'GalaxyMapperCommon1',
                provider = function()
                    return ''
                end,
            }
        },
        {
            RightLspClient = {
                highlight = 'GalaxyMapperCommon4',
                provider = function()
                    if #vim.tbl_keys(vim.lsp.buf_get_clients()) >= 1 then
                        local lsp_client_name_first = vim.lsp.get_client_by_id(tonumber(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients())):match('%d+'))).name:match('%l+')

                        if lsp_client_name_first == nil then
                            return #vim.tbl_keys(vim.lsp.buf_get_clients()) .. ': '
                        else
                            return #vim.tbl_keys(vim.lsp.buf_get_clients()) .. ':' .. lsp_client_name_first .. ' '
                        end
                    else
                        return ' '
                    end
                end,
                separator = ' ',
                separator_highlight = 'GalaxyMapperCommon4'
            }
        },
        {
            RightLspClientSeparator = {
                highlight = 'GalaxyMapperCommon4',
                provider = function()
                    return ''
                end,
                separator = ' ',
                separator_highlight = 'GalaxyMapperCommon4'
            }
        },
        {
            RightFileSize = {
                highlight = 'GalaxyMapperCommon4',
                provider = 'FileSize',
                separator = ' ',
                separator_highlight = 'GalaxyMapperCommon4'
            }
        },
        {
            RightTabStop = {
                highlight = 'GalaxyMapperCommon4',
                provider = function()
                    return string.format('%s', vim.bo.tabstop) .. ':'
                end,
            }
        },
        {
            RightFileType = {
                provider = function()
                    if vim.bo.fileencoding == 'utf-8' then
                        vim.cmd('highlight link GalaxyRightFileType GalaxyMapperCommon4')
                    else
                        vim.cmd('highlight link GalaxyRightFileType GalaxyMapperCommon8')
                    end

                    return string.format('%s', vim.bo.filetype)
                end,
            }
        },
        {
            RightFileEncoding = {
                highlight = 'GalaxyMapperCommon4',
                provider = function()
                    local icons = {
                        dos = '',
                        mac  = '',
                        unix = ''
                    }
                    if icons[vim.bo.fileformat] then
                        return icons[vim.bo.fileformat]
                    else
                        return ''
                    end
                end,
                separator = ' ',
                separator_highlight = 'GalaxyMapperCommon4'
            }
        },
        {
            RightFileEncodingSeparator = {
                highlight = 'GalaxyMapperCommon7',
                provider = function()
                    return ''
                end,
                separator = ' ',
                separator_highlight = 'GalaxyMapperCommon7'
            }
        },
        {
            RightPositionNumerical = {
                highlight = 'GalaxyMapperCommon2',
                provider = function()
                    return string.format('%s:%s  ', vim.fn.line('.'), vim.fn.col('.'))
                end,
                separator = ' ',
                separator_highlight = 'GalaxyMapperCommon2'
            }
        },
        {
            RightPositionPercentage = {
                highlight = 'GalaxyMapperCommon2',
                provider = function ()
                    local percent = math.floor(100 * vim.fn.line('.') / vim.fn.line('$'))
                    return string.format('%s%s ☰', percent, '%')
                end,
                separator = ' ',
                separator_highlight = 'GalaxyMapperCommon2'
            }
        },
        {
            RightPositionSeparator = {
                highlight = 'GalaxyMapperCommon2',
                provider = function()
                    return '  '
                end
            }
        }
    }

    require ('galaxyline').section.short_line_left = {
        {
            ShortLineLeftBufferType = {
                highlight = 'GalaxyMapperCommon2',
                provider = function ()
                    local BufferTypeMap = {
                        ['Mundo'] = 'Mundo History',
                        ['MundoDiff'] = 'Mundo Diff',
                        ['NvimTree'] = 'Nvim Tree',
                        ['fugitive'] = 'Fugitive',
                        ['fugitiveblame'] = 'Fugitive Blame',
                        ['help'] = 'Help',
                        ['minimap'] = 'Minimap',
                        ['qf'] = 'Quick Fix',
                        ['tabman'] = 'Tab Manager',
                        ['tagbar'] = 'Tagbar',
                        ['toggleterm'] = 'Terminal'
                    }
                    local name = BufferTypeMap[vim.bo.filetype] or 'Editor'
                    return string.format('  %s ', name)
                end,
                separator = ' ',
                separator_highlight = 'GalaxyMapperCommon7'
            }
        },
        {
            ShortLineLeftWindowNumber = {
                highlight = 'GalaxyMapperCommon6',
                provider = function()
                    return '  ' .. vim.api.nvim_win_get_number(vim.api.nvim_get_current_win()) .. ' '
                end,
                separator = '',
                separator_highlight = 'GalaxyMapperCommon1'
            }
        }
    }

    require ('galaxyline').section.short_line_right = {
        {
            ShortLineRightBlank = {
                highlight = 'GalaxyMapperCommon6',
                provider = function()
                    if vim.bo.filetype == 'toggleterm' then
                        return ' ' .. vim.api.nvim_buf_get_var(0, 'toggle_number') .. ' '
                    end
                    return '  '
                end,
                separator = '',
                separator_highlight = 'GalaxyMapperCommon1'
            }
        },
        {
            ShortLineRightInformational = {
                highlight = 'GalaxyMapperCommon2',
                provider = function()
                    return ' Neovim '
                end,
                separator = '',
                separator_highlight = 'GalaxyMapperCommon7'
            }
        }
    }
end

return M
