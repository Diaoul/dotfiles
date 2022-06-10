local M = {}

function M.config()
    require('fidget').setup{
        text = {
            spinner = 'dots',
        },
    }
end

return M
