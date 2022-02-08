local M = {}

function M.config()
    require('nvim-autopairs').setup { check_ts = true }

    -- cmp integration
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({
        map_char = { tex = '' }
    }))
end

return M
