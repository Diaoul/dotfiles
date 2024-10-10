return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle() end, desc = "Dap UI" },
        { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
      },
      opts = {},
      config = function(_, opts)
        local dap = require("dap")
        local daputils = require("dap.utils")
        local dapui = require("dapui")

        -- setup dap config by VSCode launch.json file
        require("dap.ext.vscode").load_launchjs()

        -- setup dapui
        dapui.setup(opts)

        -- open and close windows automatically
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end

        -- add debugpy capability to specify args as string
        dap.listeners.on_config["debugpy"] = function(config)
          -- copy the config and split the args if it is a string
          local c = {}

          for k, v in pairs(vim.deepcopy(config)) do
            if k == "args" and type(v) == "string" then
              c[k] = daputils.splitstr(v)
            else
              c[k] = v
            end
          end

          return c
        end
      end,
    },

    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },

    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        ensure_installed = {
          "python",
        },
        automatic_installation = true,
      },
    },

    -- python
    {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dm", function() require('dap-python').test_method() end, desc = "Debug Nearest Method", ft = "python" },
        { "<leader>dk", function() require('dap-python').test_class() end, desc = "Debug Nearest Class", ft = "python" },
      },
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(path .. "/venv/bin/python")
      end,
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go To Line (no execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>d<down>", function() require("dap").down() end, desc = "Down" },
    { "<leader>d<up>", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },
  config = function()
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    -- dap signs
    local config = require("diaoul.config")
    for name, sign in pairs(config.icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end
  end,
}
