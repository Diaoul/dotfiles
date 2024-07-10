return {
  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      vim.notify = require("notify")
    end,
  },

  -- Better `vim.ui`
  {
    "stevearc/dressing.nvim",
    opts = {},
  },

  -- Status line
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

  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      -- shortcuts
      { "<s-left>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<s-right>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<s-up>", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      -- buffer
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
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

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        char = require("diaoul.config").icons.indent,
        tab_char = require("diaoul.config").icons.indent,
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
    main = "ibl",
  },

  -- Highlight current indentation level
  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = require("diaoul.config").icons.indent,
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Nicer UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- Disable this to use fidget instead
        -- enable = false,
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        -- Route to the mini view
        {
          filter = {
            event = "msg_show",
            any = {
              -- Written messages
              { find = "%d+L, %d+B" },
              -- Undo/redo
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              -- Adding/deleting lines
              { find = "%d more lines" },
              { find = "%d fewer lines" },
              -- Yanking
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

  -- Status column
  -- TODO: fixed width with diagnostics > line number > git signs or fold
  {
    "luukvbaal/statuscol.nvim",
    opts = {
      relculright = true,
    },
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      color_icons = true,
    },
  },

  -- UI components
  { "MunifTanjim/nui.nvim", lazy = true },

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

  -- Dashboard
  -- TODO: rework this (to include recent projects?)
  {
    "nvimdev/dashboard-nvim",
    dependencies = {
      "MaximilianLloyd/ascii.nvim",
    },
    event = "VimEnter",
    opts = function()
      local ascii = require("ascii")
      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = ascii.art.text.neovim.ansi_shadow,
          -- stylua: ignore
          center = {
            { desc = " Find file",       icon = " ", key = "f", action = 'lua require("diaoul.util.pick").files()' },
            { desc = " New file",        icon = " ", key = "n", action = "ene | startinsert" },
            { desc = " Recent files",    icon = " ", key = "r", action = 'lua require("telescope.builtin").oldfiles()' },
            { desc = " Find text",       icon = " ", key = "g", action = 'lua require("telescope.builtin").live_grep()' },
            { desc = " Config",          icon = " ", key = "c", action = 'lua require("diaoul.util.pick").config_files()' },
            { desc = " Restore Session", icon = " ", key = "s", action = 'lua require("persistence").load()' },
            { desc = " Lazy",            icon = "󰒲 ", key = "l", action = "Lazy" },
            { desc = " Quit",            icon = " ", key = "q", action = "qa" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },
}
