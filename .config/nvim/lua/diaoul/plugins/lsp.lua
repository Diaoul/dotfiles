return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        severity_sort = true,
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = require("diaoul.config").icons.diagnostic_prefix,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = require("diaoul.config").icons.diagnostics.error,
            [vim.diagnostic.severity.WARN] = require("diaoul.config").icons.diagnostics.warn,
            [vim.diagnostic.severity.HINT] = require("diaoul.config").icons.diagnostics.hint,
            [vim.diagnostic.severity.INFO] = require("diaoul.config").icons.diagnostics.info,
          },
        },
      },
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
      -- configure diagnostics
      vim.diagnostic.config(opts.diagnostics)

      -- lsp and buffer local mappings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
          -- mappings
          -- stylua: ignore
          local mappings = {
            { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
            { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
            { "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "v" }, desc = "Code Action" },
            { "<leader>cc", vim.lsp.codelens.run, mode = { "n", "v" }, desc = "Run Codelens" },
            { "<leader>cC", vim.lsp.codelens.refresh, mode = "n", desc = "Refresh & Display Codelens" },
            { "<leader>cR", function() Snacks.rename.rename_file() end, mode = "n", desc = "Rename File" },
            { "<leader>cr", vim.lsp.buf.rename, mode = "n", expr = true, desc = "Rename" },
          }
          for _, map in ipairs(mappings) do
            local mode = map.mode or "n"
            local mapping_opts = {
              buffer = event.buf,
              desc = map.desc,
              expr = map.expr,
            }
            vim.keymap.set(mode, map[1], map[2], mapping_opts)
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- highlight word on CursorHold
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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
        end,
      })

      -- configuration
      require("mason").setup()

      -- add cmp capabilities
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- configure servers
      for server_name, server in pairs(opts.servers) do
        server.capabilities = capabilities
        vim.lsp.config(server_name, server)
      end

      -- install servers
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
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
