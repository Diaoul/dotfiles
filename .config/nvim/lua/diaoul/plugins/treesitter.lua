return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "latex",
        "lua",
        "luadoc",
        "luau",
        "markdown",
        "markdown_inline",
        "ninja",
        "python",
        "query",
        "regex",
        "rst",
        "scss",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")

      if not TS.get_installed then
        vim.notify("Please restart Neovim and run `:TSUpdate`", vim.log.levels.ERROR)
        return
      end

      TS.setup(opts)

      -- parser and query cache
      local installed, queries = {}, {}

      local function refresh_installed()
        installed = {}
        for _, lang in ipairs(TS.get_installed("parsers")) do
          installed[lang] = true
        end
      end
      refresh_installed()

      local function have(ft, query)
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang or not installed[lang] then
          return false
        end
        if query then
          local key = lang .. ":" .. query
          if queries[key] == nil then
            queries[key] = vim.treesitter.query.get(lang, query) ~= nil
          end
          return queries[key]
        end
        return true
      end

      -- install missing parsers
      local to_install = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, opts.ensure_installed or {})
      if #to_install > 0 then
        TS.install(to_install, { summary = true }):await(function()
          refresh_installed()
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("diaoul_treesitter", { clear = true }),
        callback = function(ev)
          local ft = ev.match
          local lang = vim.treesitter.language.get_lang(ft)

          local function enabled(feat, query)
            local f = opts[feat] or {}
            return f.enable ~= false
              and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang or ""))
              and have(ft, query)
          end

          if enabled("highlight", "highlights") then
            pcall(vim.treesitter.start, ev.buf)
          end

          if enabled("indent", "indents") then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          if enabled("folds", "folds") then
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
        end,
      })
    end,
  },

  -- treesitter textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = {
          enable = true,
          set_jumps = true,
        },
      })

      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      }

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang or not vim.treesitter.query.get(lang, "textobjects") then
          return
        end

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local name = query:gsub("@", ""):gsub("%..*", "")
            local desc = (key:sub(1, 1) == "[" and "Prev " or "Next ")
              .. name:sub(1, 1):upper() .. name:sub(2)
              .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
            vim.keymap.set({ "n", "x", "o" }, key, function()
              if vim.wo.diff and key:find("[cC]") then
                return vim.cmd("normal! " .. key)
              end
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, { buffer = buf, silent = true, desc = desc })
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("diaoul_treesitter_textobjects", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },

  -- automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },
}
