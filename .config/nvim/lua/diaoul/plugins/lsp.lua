return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- TODO: fidget?
    },
    opts = {
      -- server configuration
      servers = {
        ansiblels = {},
        bashls = {},
        dockerls = {},
        jsonls = {},
        lua_ls = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              checkThirdParty = false,
            },
          },
          telemetry = { enable = false },
        },
        pkgbuild_language_server = {},
        ruff_lsp = {},
        html = {},
        rust_analyzer = {},
        taplo = {},
        tsserver = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- global mappings
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

      -- diagnostic signs
      for name, icon in pairs(require("diaoul.config").icons.diagnostics) do
        name = "DiagnosticSign" .. name:gsub("^%l", string.upper)
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      -- lsp and buffer local mappings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local map = function(modes, keys, func, desc)
            vim.keymap.set(modes, keys, func, { buffer = ev.buf, desc = desc })
          end

          -- common keymaps
          map("n", "<leader>cl", "<cmd>LspInfo<cr>", "Lsp Info")
          -- TODO: inc-rename?
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
          map("n", "gr", require("telescope.builtin").lsp_references, "Goto References")
          map("n", "gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
          map("n", "<leader>gy", require("telescope.builtin").lsp_type_definitions, "Type Definition")
          map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
          map("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
          map("n", "K", vim.lsp.buf.hover, "Hover")

          -- see `:help K` for why this keymap
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

          -- lesser used LSP functionality
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "Workspace List Folders")
        end,
      })

      -- configuration
      require("mason").setup()
      require("mason-lspconfig").setup()
      require("neodev").setup()

      -- add cmp capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- install servers
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(opts.servers),
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            settings = opts.servers[server_name],
            filetypes = (opts.servers[server_name] or {}).filetypes,
          })
        end,
      })

      -- add border to the windows
      require("lspconfig.ui.windows").default_options.border = "single"
      vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    config = function(_, opts)
      require("mason").setup(opts)
      -- ensure some packages are installed
      -- see https://github.com/williamboman/mason.nvim/issues/1338
      local registry = require("mason-registry")

      local packages = {
        "ansible-lint",
        "eslint_d",
        "lua-language-server",
        "mypy",
        "ruff",
        "rust-analyzer",
        "shellcheck",
        "stylua",
        "yamllint",
      }

      registry.refresh(function()
        for _, pkg_name in ipairs(packages) do
          local pkg = registry.get_package(pkg_name)
          if not pkg:is_installed() then
            vim.notify(string.format("[mason] Installing package %s", pkg_name), vim.log.levels.INFO)
            pkg:install()
          end
        end
      end)
    end,
  },
}
