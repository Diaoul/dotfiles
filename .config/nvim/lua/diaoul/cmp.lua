local M = {}

function M.config()
    local cmp = require 'cmp'
    local lspkind = require 'lspkind'
    local luasnip = require 'luasnip'
    -- local tabout = require 'tabout'

    cmp.setup {
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = {
            -- ['<Tab>'] = cmp.mapping(function(fallback)
            --     if cmp.visible() then
            --         cmp.select_next_item()
            --     elseif luasnip.expand_or_jumpable() then
            --         luasnip.expand_or_jump()
            --     else
            --         tabout.tabout()
            --     end
            -- end, { 'i', 's' }),

            -- ['<S-Tab>'] = cmp.mapping(function(fallback)
            --     if cmp.visible() then
            --         cmp.select_prev_item()
            --     elseif luasnip.jumpable(-1) then
            --         luasnip.jump(-1)
            --     else
            --         tabout.taboutBack()
            --     end
            -- end, { 'i', 's' }),
            -- ['<C-n>'] = cmp.mapping.select_next_item({
            --     behavior = cmp.SelectBehavior.Insert
            -- }),
            -- ['<C-p>'] = cmp.mapping.select_prev_item({
            --     behavior = cmp.SelectBehavior.Insert
            -- }),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.close(),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
            { name = 'nvim_lua' },
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 5 },
            -- { name = 'spell' },
        },
        formatting = {
            format = lspkind.cmp_format({
                with_text = true,
                menu = {
                    nvim_lua = "[api]",
                    nvim_lsp = "[LSP]",
                    path = "[path]",
                    luasnip = "[snip]",
                    buffer = "[buf]",
                }
            }),
        },
        --     format = function(_, vim_item)
        --         vim_item.kind = string.format(
        --             '%s [%s]',
        --             lsp.kinds[vim_item.kind],
        --             vim_item.kind
        --         )
        --         return vim_item
        --     end,
        -- },
        experimental = {
            native_menu = false,
            ghost_text = true
        },
    }
end

return M
