return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        ansiblels = {},
        bashls = {},
        clangd = {
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
        },
        dockerls = {},
        jsonls = {},
        lua_ls = {
          settings = {
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
        },
        basedpyright = {},
        ruff = {},
        html = {},
        rust_analyzer = {},
        taplo = {},
        ts_ls = {},
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
      -- diagnostic signs
      for name, icon in pairs(require("diaoul.config").icons.diagnostics) do
        name = "DiagnosticSign" .. name:gsub("^%l", string.upper)
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      -- lsp and buffer local mappings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
          -- mappings
          local map = function(modes, keys, func, desc)
            vim.keymap.set(modes, keys, func, { buffer = event.buf, desc = desc })
          end
          -- stylua: ignore start
          map("n", "<leader>cl", "<cmd>LspInfo<cr>", "Lsp Info")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "gr", function() require("telescope.builtin").lsp_references({ trim_text = true }) end, "Goto References")
          map("n", "gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
          map("n", "gy", require("telescope.builtin").lsp_type_definitions, "Goto Type Definition")
          map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
          -- stylua: ignore end

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- disable hover for ruff
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          -- highlight word on CursorHold
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp_detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp_highlight", buffer = event2.buf })
              end,
            })
          end

          -- toggle inlay hints
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay Hints")
          end
        end,
      })

      -- configuration
      require("mason").setup()
      require("mason-lspconfig").setup()

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
          -- only setup lsps defined above
          if not opts.servers[server_name] then
            vim.notify(
              ("Server %s installed but not configured"):format(server_name),
              vim.log.levels.WARN,
              { title = "LSP" }
            )
            return
          end
          local server_opts = { capabilities = capabilities }
          for k, v in pairs(opts.servers[server_name]) do
            server_opts[k] = v
          end
          require("lspconfig")[server_name].setup(server_opts)
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
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },
}
