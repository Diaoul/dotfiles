return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter", -- not needed if using cmp
    build = ":Copilot auth",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true, -- set to false if using cmp
        auto_trigger = true,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-e>",
        },
      },
    },
  },
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    -- TODO: use ext_opts to customize the colors when in snippet
    keys = {
      {
        "<C-e>",
        function()
          if require("luasnip").expand_or_locally_jumpable() then
            require("luasnip").expand_or_jump()
          end
        end,
        mode = { "i", "s" },
      },
      {
        "<C-n>",
        function()
          if require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          end
        end,
        mode = { "i", "s" },
      },
    },
  },

  -- Auto completion
  -- Expected behavior:
  --   <Tab> complete ghost text
  --   <C-Space> to trigger completion menu manually
  --   <Up> and <Down> navigate the completion menu
  --   <CR> confirm the selected item
  --
  -- Currently, support for ghost text in cmp is limited to one line only
  -- so I rely on copilot for that instead.
  -- Addionally, indentation is messed up with cmp-copilot.
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
      -- disabled in favor of copilot
      -- { "zbirenbaum/copilot-cmp", dependencies = "copilot.lua", opts = {} },
    },
    ---@return cmp.ConfigSchema
    opts = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      -- highlight for ghost text
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      -- configuration
      return {
        -- automatically select the first item in the menu, disabled for copilot
        -- completion = {
        --   completeopt = "menu,menuone,noinsert",
        -- },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<C-Space>"] = { i = cmp.mapping.complete() },
          ["<Down>"] = { i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<Up>"] = { i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<C-b>"] = { i = cmp.mapping.scroll_docs(-4) },
          ["<C-f>"] = { i = cmp.mapping.scroll_docs(4) },
          ["<C-q>"] = { i = cmp.mapping.abort() },
          ["<CR>"] = { i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }) },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
            elseif cmp.visible() and cmp.get_active_entry() then
              cmp.complete({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            -- disabled to use default luasnip mappings
            -- elseif luasnip.expand_or_jumpable() then
            --   luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          -- disabled to use default luasnip mappings
          -- ["<S-Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   elseif luasnip.jumpable(-1) then
          --     luasnip.jump(-1)
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          {
            name = "luasnip",
            entry_filter = function()
              local context = require("cmp.config.context")
              return not context.in_treesitter_capture("string") and not context.in_syntax_group("String")
            end,
          },
          { name = "buffer" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            symbol_map = require("diaoul.config").icons.kinds,
          }),
        },
        experimental = {
          -- disabled as it conflicts with copilot
          -- ghost_text = {
          --   hl_group = "CmpGhostText",
          -- },
        },
      }
    end,
  },

  -- Auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  -- Surround actions
  {
    "echasnovski/mini.surround",
    opts = {
      silent = true,
    },
  },

  -- Comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false, -- to speed up loading
    },
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      -- enable ts context commentstring
      -- see https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#minicomment
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  -- Better text-objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      -- add similar mappings as the ones from treesitter-textobjects
      -- see https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-select
      local ai = require("mini.ai")
      return {
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
  },
}
