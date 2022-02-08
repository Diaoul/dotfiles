local M = {}

function M.config()
    require('tabout').setup {
        tabkey = '',
        backwards_tabkey = '',
        completion = false,
    }
end

return M
