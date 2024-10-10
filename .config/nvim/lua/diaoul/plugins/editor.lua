return {
  -- File explorers
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      lsp_file_methods = {
        timeout_ms = 3000,
      },
    },
    keys = {
      {
        "<leader>fo",
        function()
          require("oil").toggle_float()
        end,
        desc = "Explorer Oil",
      },
      {
        "<leader>fO",
        function()
          require("oil").toggle_float(vim.uv.cwd())
        end,
        desc = "Explorer Oil (cwd)",
      },
      { "<leader>o", "<leader>fo", desc = "Explorer Oil", remap = true },
      { "<leader>O", "<leader>fO", desc = "Explorer Oil (cwd)", remap = true },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        desc = "Explorer NeoTree",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = require("diaoul.config").icons.tree.collapsed,
          expander_expanded = require("diaoul.config").icons.tree.expanded,
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
  },

  -- Search and replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    branch = "0.1.x",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      -- setup telescope
      local actions = require("telescope.actions")
      local trouble = require("trouble.sources.telescope")

      require("telescope").setup({
        defaults = {
          path_display = {
            truncate = 2,
          },
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
              ["<c-t>"] = trouble.open_with_trouble,
              ["<a-t>"] = trouble.open_selected_with_trouble,
            },
          },
          color_devicons = false,
        },
        pickers = {
          live_grep = {
            additional_args = { "--hidden", "--glob", "!.git/", "--trim" },
          },
          lsp_references = {
            path_display = { "smart", { truncate = 10 } },
          },
        },
      })

      local function get_visual()
        local _, ls, cs = unpack(vim.fn.getpos("v"))
        local _, le, ce = unpack(vim.fn.getpos("."))

        -- nvim_buf_get_text requires start and end args be in correct order
        ls, le = math.min(ls, le), math.max(ls, le)
        cs, ce = math.min(cs, ce), math.max(cs, ce)

        return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})[1] or ""
      end

      -- mappings
      -- shortcuts
      -- stylua: ignore start
      vim.keymap.set("n", "<leader>/", require("telescope.builtin").live_grep, { desc = "Grep" })
      vim.keymap.set("n", "<leader>:", require("telescope.builtin").command_history, { desc = "Command History" })
      vim.keymap.set("n", "<leader><space>", require("diaoul.util.pick").files, { desc = "Find Files" })
      -- find
      vim.keymap.set("n", "<leader>ff", require("diaoul.util.pick").files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fF", function() require("diaoul.util.pick").files({ cwd = require("telescope.utils").buffer_dir() }) end, { desc = "Find Files (cwd)" })
      vim.keymap.set("n", "<leader>fc", function() require("diaoul.util.pick").files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config Files" })
      vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "Find Recent" })
      vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Find Buffers" })
      vim.keymap.set("n", "<leader>fg", require("telescope.builtin").git_files, { desc = "Find Git Files" })
      -- git
      vim.keymap.set("n", "<leader>gc", require("telescope.builtin").git_commits, { desc = "Git Commits" })
      vim.keymap.set("n", "<leader>gs", require("telescope.builtin").git_status, { desc = "Git Statuses" })
      -- search
      vim.keymap.set("n", "<leader>s\"", require("telescope.builtin").registers, { desc = "Registers" })
      vim.keymap.set("n", "<leader>sb", require("telescope.builtin").current_buffer_fuzzy_find, { desc = "Current Buffer" })
      vim.keymap.set("n", "<leader>sc", require("telescope.builtin").command_history, { desc = "Command History" })
      vim.keymap.set("n", "<leader>sC", require("telescope.builtin").commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>sa", require("telescope.builtin").autocommands, { desc = "Autocommands" })
      vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "Help" })
      vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "Word" })
      vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "Grep" })
      vim.keymap.set("v", "<leader>sg", function() require("telescope.builtin").live_grep({ default_text = get_visual() }) end, { desc = "Grep" })
      vim.keymap.set("n", "<leader>sd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sD", require("telescope.builtin").diagnostics, { desc = "Diagnostics (Workspace)" })
      vim.keymap.set("n", "<leader>ss", require("telescope.builtin").lsp_document_symbols, { desc = "Symbols" })
      vim.keymap.set("n", "<leader>sS", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "Symbols (Workspace)" })
      vim.keymap.set("n", "<leader>so", require("telescope.builtin").vim_options, { desc = "VIM Options" })
      vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "Keymaps" })
      vim.keymap.set("n", "<leader>sH", require("telescope.builtin").highlights, { desc = "Highlights" })
      vim.keymap.set("n", "<leader>sM", require("telescope.builtin").man_pages, { desc = "Man Pages" })
      vim.keymap.set("n", "<leader>sR", require("telescope.builtin").resume, { desc = "Resume" })
      -- stylua: ignore end
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        mode = { "n", "v" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "File/Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunk" },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Test" },
        { "<leader>u", group = "UI" },
        { "<leader>w", group = "Windows/Workspace" },
        { "<leader>x", group = "Diagnostics/Quickfix" },
        { "[", group = "Prev" },
        { "]", group = "Next" },
        { "g", group = "Goto" },
        { "s", group = "Surround" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = require("diaoul.config").icons.git_signs.add },
        change = { text = require("diaoul.config").icons.git_signs.change },
        delete = { text = require("diaoul.config").icons.git_signs.delete },
        topdelete = { text = require("diaoul.config").icons.git_signs.topdelete },
        changedelete = { text = require("diaoul.config").icons.git_signs.changedelete },
        untracked = { text = require("diaoul.config").icons.git_signs.untracked },
      },
      count_chars = {
        [1] = "₁",
        [2] = "₂",
        [3] = "₃",
        [4] = "₄",
        [5] = "₅",
        [6] = "₆",
        [7] = "₇",
        [8] = "₈",
        [9] = "₉",
        ["+"] = "₊",
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        -- navigation
        -- NOTE: no need for the special mapping as described in gitsigns docs
        -- since I don't use fugitive nor ]c and [c
        map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        -- actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage Hunk")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>hl", gs.toggle_current_line_blame, "Toggle Current Line Blame")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
        map("n", "<leader>hq", gs.toggle_deleted, "Toggle Deleted")
        -- text objects
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        -- stylua: ignore end
      end,
    },
  },

  -- Git links
  {
    "linrongbin16/gitlinker.nvim",
    opts = {
      message = false,
      console_log = false,
    },
    keys = {
      { "<leader>gl", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Copy Git URL" },
      { "<leader>gL", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open Git URL" },
      { "<leader>gb", "<cmd>GitLink blame<cr>", mode = { "n", "v" }, desc = "Copy Git Blame URL" },
      { "<leader>gB", "<cmd>GitLink! blame<cr>", mode = { "n", "v" }, desc = "Open Git Blame URL" },
    },
  },

  -- Colorizer
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      user_default_options = { names = false },
    },
  },

  -- Buffer remove
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          -- better confirmation message
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },

  -- Better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- TODOs
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {},
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },
}
