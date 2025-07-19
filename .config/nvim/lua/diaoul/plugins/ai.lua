return {
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    event = "BufReadPost",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- mcp hub
  {
    "ravitemer/mcphub.nvim",
    cmd = "MCPHub",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    opts = {},
    keys = {
      { "<leader>am", "<cmd>MCPHub<cr>", mode = { "n" }, desc = "MCPHub" },
    },
  },

  -- avante
  {
    "yetone/avante.nvim",
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      "saghen/blink.cmp",
      "echasnovski/mini.icons",
      "ravitemer/mcphub.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "HakonHarnes/img-clip.nvim",
    },
    -- stylua: ignore
    keys = {
      { "<leader>aa", function() require("avante.api").ask() end, mode = { "n", "v" }, desc = "Ask" },
      { "<leader>an", function() require("avante.api").ask({new_chat = true}) end, mode = { "n", "v" }, desc = "New Ask" },
      { "<leader>ae", function() require("avante.api").edit() end, mode = { "v" }, desc = "Edit" },
      { "<leader>aS", function() require("avante.api").stop() end, mode = { "n" }, desc = "Stop" },
      { "<leader>ar", function() require("avante.api").refresh() end, mode = { "n" }, desc = "Refresh" },
      { "<leader>a`", function() require("avante.api").focus() end, mode = { "n" }, desc = "Focus" },
      { "<leader>at", function() require("avante.api").toggle() end, mode = { "n" }, desc = "Toggle" },
      { "<leader>ad", function() require("avante.api").toggle.debug() end, mode = { "n" }, desc = "Toggle Debug" },
      { "<leader>aH", function() require("avante.api").toggle.hint() end, mode = { "n" }, desc = "Toggle Hints" },
      { "<leader>as", function() require("avante.api").toggle.suggestion() end, mode = { "n" }, desc = "Toggle Suggestions" },
      { "<leader>aM", function() require("avante.api").select_model() end, mode = { "n" }, desc = "Select Model" },
      { "<leader>ah", function() require("avante.api").select_history() end, mode = { "n" }, desc = "Select History" },
      { "<leader>aB", function() require("avante.api").add_buffer_files() end, mode = { "n" }, desc = "Add All Open Buffers" },
    },
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      hints = { enabled = false },
      provider = "claude",
      behaviour = {
        auto_set_keymaps = false,
      },
      file_selector = { provider = "snacks" },
      selector = { provider = "snacks" },
      input = { provider = "snacks" },
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
      end,
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      extensions = {
        avante = {
          make_slash_commands = true,
        },
      },
      mappings = {
        submit = {
          insert = "<C-CR>",
        },
        sidebar = {
          close_from_input = { normal = "q" },
          switch_windows = "`",
          reverse_switch_windows = "<S-`>",
        },
        files = {
          add_current = false,
        },
      },
      windows = {
        ask = {
          start_insert = false,
        },
        edit = {
          border = "rounded",
        },
      },
    },
  },
}
