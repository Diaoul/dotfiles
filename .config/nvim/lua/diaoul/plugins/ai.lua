return {
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
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      "hrsh7th/nvim-cmp",
      "echasnovski/mini.icons",
      "ravitemer/mcphub.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "HakonHarnes/img-clip.nvim",
    },
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      hints = { enabled = false },
      provider = "claude",
      auto_suggestions_provider = nil,
      behaviour = {
        auto_suggestions = false,
      },
      file_selector = {
        provider = "snacks",
        provider_opts = {},
      },
      selector = { provider = "snacks" },
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
      input = { provider = "snacks" },
    },
  },
}
