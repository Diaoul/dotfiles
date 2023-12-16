return {
  -- gruvbox
  -- disabled because poor support for all the UI stuff I use
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   opts = {
  --     italic = {
  --       strings = false,
  --     },
  --   },
  --   init = function()
  --     vim.cmd.colorscheme("gruvbox")
  --   end,
  -- },

  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    init = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- rosé pine
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   init = function()
  --     vim.cmd.colorscheme("rose-pine")
  --   end,
  -- },

  -- kanagawa
  -- {
  --   "rebelot/kanagawa.nvim",
  --   init = function()
  --     vim.cmd.colorscheme("kanagawa")
  --   end,
  -- },

  -- my own gruvbox.nvim
  -- {
  --   "Diaoul/gruvbox.nvim",
  --   dir = "~/projects/gruvbox.nvim",
  --   dev = true,
  --   init = function()
  --     vim.cmd.colorscheme("rose-pine")
  --   end,
  -- },
}
