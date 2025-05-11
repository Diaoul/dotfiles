return {
  -- status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local theme = nil
      -- theme based on ellisonleao/gruvbox.nvim
      if package.loaded["gruvbox"] then
        local colors = require("gruvbox").palette

        theme = {
          normal = {
            a = { bg = colors.light4, fg = colors.dark0, gui = "bold" },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light2 },
          },
          insert = {
            a = { bg = colors.bright_blue, fg = colors.dark0, gui = "bold" },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light2 },
          },
          visual = {
            a = { bg = colors.bright_orange, fg = colors.dark0, gui = "bold" },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light2 },
          },
          replace = {
            a = { bg = colors.bright_yellow, fg = colors.dark0, gui = "bold" },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light2 },
          },
          command = {
            a = { bg = colors.bright_red, fg = colors.dark0, gui = "bold" },
            b = { bg = colors.dark2, fg = colors.light1 },
            c = { bg = colors.dark1, fg = colors.light2 },
          },
          inactive = {
            a = { bg = colors.dark1, fg = colors.light4, gui = "bold" },
            b = { bg = colors.dark1, fg = colors.light4 },
            c = { bg = colors.dark1, fg = colors.light4 },
          },
        }
      end
      return {
        options = {
          theme = theme,
          -- comment for default
          -- style: slanted
          component_separators = "/",
          section_separators = { left = "", right = "" },
          -- style: boxy
          -- component_separators = "|",
          -- section_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "starter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diff",
              symbols = require("diaoul.config").icons.git,
            },
          },
          lualine_c = {
            {
              "filetype",
              separator = "",
              padding = { left = 1, right = 0 },
              colored = false,
              icon_only = true,
            },
            {
              "filename",
              path = 1,
              symbols = require("diaoul.config").icons.file,
            },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return require("noice").api.status.command.has()
              end,
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return require("noice").api.status.mode.has()
              end,
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
            },
            {
              "diagnostics",
              symbols = require("diaoul.config").icons.diagnostics,
            },
          },
          lualine_y = {
            { "progress" },
          },
          lualine_z = {
            { "location", padding = { right = 1 } },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      -- shortcuts
      { "<s-left>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
      { "<s-right>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<s-up>", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      -- buffer
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers To The Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers To The Left" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = require("diaoul.config").icons.diagnostics
          local ret = (diag.error and icons.error .. diag.error .. " " or "")
            .. (diag.warning and icons.warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        hover = {
          enabled = true,
          delay = 50,
          reveal = { "close" },
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- nicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        -- route to the mini view
        {
          filter = {
            event = "msg_show",
            any = {
              -- written messages
              { find = "%d+L, %d+B" },
              -- undo/redo
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              -- adding/deleting lines
              { find = "%d more lines" },
              { find = "%d fewer lines" },
              -- yanking
              { find = "%d lines yanked" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+Noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },

  -- icons
  {
    "echasnovski/mini.icons",
    opts = {},
    lazy = true,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- breadcrumbs
  {
    "utilyre/barbecue.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    opts = {
      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      kinds = require("diaoul.config").icons.kinds,
    },
  },

  -- smart qol
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      -- disabled because glitchy when holding keys
      -- see https://github.com/folke/snacks.nvim/pull/1799
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  -- stylua: ignore
  keys = {
    -- top pickers & explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- lsp
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "LSP Info" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- other
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gc", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    ---@diagnostic disable-next-line: missing-fields
    { "<leader>gy", function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false }) end, mode = { "n", "v" }, desc = "Git Yank URL" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- override print to use snacks for `:=` command

          -- create some toggle mappings
          -- stylua: ignore start
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.animate():map("<leader>ua")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.dim():map("<leader>uD")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.profiler():map("<leader>dpp")
          Snacks.toggle.profiler_highlights():map("<leader>dph")
          Snacks.toggle.scroll():map("<leader>uS")
          Snacks.toggle.treesitter():map("<leader>uT")
          require("diaoul.util.formatting").snacks_toggle():map("<leader>uf")
          require("diaoul.util.formatting").snacks_toggle(true):map("<leader>uF")
          -- stylua: ignore end
        end,
      })
    end,
  },
}
