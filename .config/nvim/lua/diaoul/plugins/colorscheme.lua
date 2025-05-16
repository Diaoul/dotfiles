return {
  -- rosé pine
  {
    "rose-pine/neovim",
    lazy = false, -- make sure we load this during startup (main color scheme)
    priority = 1000, -- make sure to load this before all the other start plugins
    name = "rose-pine",
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme rose-pine]])
    end,
  },

  -- nightfox
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },

  -- gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {
      italic = {
        strings = false,
      },
    },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
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
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },

  -- kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
  },
}
