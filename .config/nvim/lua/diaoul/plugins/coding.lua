return {
  -- Neovim completions
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  -- Manage libuv types with lazy. Plugin will never be loaded
  { "Bilal2453/luvit-meta", lazy = true },

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
      filetypes = {
        markdown = true,
        help = true,
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
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
        },
        dependencies = { "rafamadriz/friendly-snippets" },
      },
      -- disabled in favor of copilot
      -- { "zbirenbaum/copilot-cmp", dependencies = "copilot.lua", opts = {} },
    },
    ---@return cmp.ConfigSchema
    opts = function()
      local cmp = require("cmp")

      -- highlight for ghost text
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      -- configure auto-select
      local auto_select = false

      -- configuration
      return {
        auto_brackets = { "python" }, -- configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = {
          ["<C-Space>"] = { i = cmp.mapping.complete() },
          ["<Down>"] = { i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
          ["<Up>"] = { i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
          ["<C-b>"] = { i = cmp.mapping.scroll_docs(-4) },
          ["<C-f>"] = { i = cmp.mapping.scroll_docs(4) },
          ["<C-q>"] = { i = cmp.mapping.abort() },
          ["<CR>"] = { i = cmp.mapping.confirm({ select = auto_select }) },
          ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ["<Tab>"] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
            elseif cmp.visible() and cmp.get_active_entry() then
              cmp.complete({ select = true })
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "lazydev", group_index = 0 },
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "snippets" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = function(_, item)
            local icon, hl = MiniIcons.get("lsp", item.kind)
            item.kind = icon .. " " .. item.kind
            item.kind_hl_group = hl
            return item
          end,
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
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
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
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          i = ai.indent, -- indent
          g = ai.buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
      }

      local ret = { mode = { "o", "x" } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then
            desc = desc:gsub(" with ws", "")
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      require("which-key").add(ret, { notify = false })
    end,
  },
}
