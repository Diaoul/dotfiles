return {
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        desc = "Explorer NeoTree",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree", remap = true },
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
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = require("diaoul.config").icons.tree.collapsed,
          expander_expanded = require("diaoul.config").icons.tree.expanded,
        },
      },
    },
  },

  -- Search and replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").toggle() end, desc = "Search and replace in files (toggle)" },
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
      local trouble = require("trouble.providers.telescope")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
              ["<c-t>"] = trouble.open_with_trouble,
              ["<a-t>"] = trouble.open_selected_with_trouble,
            },
          },
          color_devicons = false,
        },
      })

      -- mappings
      -- shortcuts
      -- stylua: ignore start
      vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep, { desc = 'Grep' })
      vim.keymap.set('n', '<leader>:', require('telescope.builtin').command_history, { desc = 'Command History' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = 'Find Files' })
      -- find
      -- stylua: ignore start
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>fc', function() require('telescope.builtin').find_files({ cwd = "~/.config/nvim/" }) end, { desc = 'Find config files' })
      vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = 'Find Recent' })
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find Buffers' })
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = 'Find Git Files' })
      -- git
      -- stylua: ignore start
      vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_commits, { desc = 'Git Commits' })
      vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = 'Git Statuses' })
      -- search
      -- stylua: ignore start
      vim.keymap.set('n', '<leader>s"', require('telescope.builtin').registers, { desc = 'Registers' })
      vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find, { desc = 'Current Buffer' })
      vim.keymap.set('n', '<leader>sc', require('telescope.builtin').command_history, { desc = 'Command History' })
      vim.keymap.set('n', '<leader>sC', require('telescope.builtin').commands, { desc = 'Commands' })
      vim.keymap.set('n', '<leader>sa', require('telescope.builtin').autocommands, { desc = 'Autocommands' })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = 'Help' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', require('telescope.builtin').grep_string, { desc = 'Word' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = 'Grep' })
      vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, { desc = 'Diagnostics' })
      vim.keymap.set('n', '<leader>sD', require('telescope.builtin').diagnostics, { desc = 'Diagnostics (Workspace)' })
      vim.keymap.set('n', "<leader>ss", require("telescope.builtin").lsp_document_symbols, { desc = 'Goto Symbols' })
      vim.keymap.set('n', "<leader>sS", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = 'Goto Symbols (Workspace)' })
      vim.keymap.set('n', "<leader>so", require("telescope.builtin").vim_options, { desc = 'VIM Options' })
      vim.keymap.set('n', "<leader>sk", require("telescope.builtin").keymaps, { desc = 'Keymaps' })
      vim.keymap.set('n', "<leader>sH", require("telescope.builtin").highlights, { desc = 'Highlights' })
      vim.keymap.set('n', "<leader>sM", require("telescope.builtin").man_pages, { desc = 'Man Pages' })
      vim.keymap.set('n', '<leader>sR', require('telescope.builtin').resume, { desc = 'Resume' })
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.register({
        -- TODO: mappings are wrong
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>t"] = { name = "+test" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows/workspace" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
    end,
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

        -- navigation
        -- TODO: they do it differently in git signs default config and kickstart because of conflict with [c and fugitive
        -- see https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L131C12-L131C12
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle Current Line Blame")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map("n", "<leader>tb", gs.toggle_deleted, "Toggle Deleted")

        -- text objects
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    "RRethy/vim-illuminate",
    opts = {
      delay = 200,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      -- mappings
      -- stylua: ignore
      vim.keymap.set("n", "]]", require("illuminate").goto_next_reference, { desc = "Next Reference" })
      vim.keymap.set("n", "[[", require("illuminate").goto_prev_reference, { desc = "Previous Reference" })
    end,
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
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
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
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },
}
