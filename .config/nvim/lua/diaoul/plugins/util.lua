return {
  -- startup time
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- store
  {
    "alex-popov-tech/store.nvim",
    -- see https://github.com/alex-popov-tech/store.nvim/issues/6
    -- dependencies = {
    --   "OXY2DEV/markview.nvim",
    -- },
    cmd = "Store",
    -- stylua: ignore
    keys = {
      { "<leader>s", function() require("store").open() end, desc = "Open Plugin Store" },
    },
    opts = {},
  },

  -- library
  { "nvim-lua/plenary.nvim", lazy = true },
}
