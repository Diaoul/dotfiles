---@param bufnr integer
---@return boolean
local function is_k8s_manifest(bufnr)
  local has_api_version, has_kind = false, false
  for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    has_api_version = has_api_version or line:find("^apiVersion:") ~= nil
    has_kind = has_kind or line:find("^kind:") ~= nil
    if has_api_version and has_kind then
      return true
    end
  end
  return false
end

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
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
        copilot = {},
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
        marksman = {},
        rust_analyzer = {},
        taplo = {},
        ts_ls = {},
        -- Kubernetes manifests go to yayamlls instead
        yamlls = {
          root_dir = function(bufnr, on_dir)
            if not is_k8s_manifest(bufnr) then
              on_dir(vim.fs.root(bufnr, { ".git" }))
            end
          end,
          settings = {
            yaml = {
              customTags = {
                "!env_var scalar",
                "!include scalar",
                "!include_dir_list scalar",
                "!include_dir_merge_list scalar",
                "!include_dir_merge_named scalar",
                "!include_dir_named scalar",
                "!input scalar",
                "!secret scalar",
              },
            },
          },
        },
        home_assistant = {
          workspace_required = true,
          settings = {
            ["vscode-home-assistant"] = {
              hostUrl = os.getenv("HASS_URL"),
              longLivedAccessToken = os.getenv("HASS_TOKEN"),
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
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client == nil then
            return
          end

          -- mappings (only set when the client supports the required method)
          -- stylua: ignore
          local mappings = {
            { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "textDocument/signatureHelp" },
            { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "textDocument/signatureHelp" },
            { "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "v" }, desc = "Code Action", has = "textDocument/codeAction" },
            { "<leader>cA", function() vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } }) end, desc = "Source Action", has = "textDocument/codeAction" },
            { "<leader>co", function() vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true }) end, desc = "Organize Imports", has = "textDocument/codeAction" },
            { "<leader>cc", vim.lsp.codelens.run, mode = { "n", "v" }, desc = "Run Codelens", has = "textDocument/codeLens" },
            { "<leader>cC", vim.lsp.codelens.refresh, mode = "n", desc = "Refresh & Display Codelens", has = "textDocument/codeLens" },
            { "<leader>cR", function() Snacks.rename.rename_file() end, mode = "n", desc = "Rename File" },
            { "<leader>cr", vim.lsp.buf.rename, mode = "n", expr = true, desc = "Rename", has = "textDocument/rename" },
          }
          for _, map in ipairs(mappings) do
            if not map.has or client:supports_method(map.has) then
              vim.keymap.set(map.mode or "n", map[1], map[2], {
                buffer = event.buf,
                desc = map.desc,
                expr = map.expr,
              })
            end
          end

          -- disable hover in favor of basedpyright
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          -- attach navic (first symbol provider wins, it supports only one per buffer)
          if
            client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol)
            and vim.b[event.buf].navic_client_id == nil
          then
            require("nvim-navic").attach(client, event.buf)
          end

          -- enable inline completion
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, event.buf) then
            vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
          end

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

      -- disable home assistant if missing config
      if (os.getenv("HASS_URL") or "") == "" or (os.getenv("HASS_TOKEN") or "") == "" then
        opts.servers.home_assistant = nil
      end

      -- configuration
      require("mason").setup()

      -- install and enable only from list
      local server_names = vim.tbl_keys(opts.servers)
      require("mason-lspconfig").setup({
        ensure_installed = server_names,
        automatic_enable = server_names,
      })

      -- add cmp capabilities
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- configure servers
      for server_name, server in pairs(opts.servers) do
        server.capabilities = capabilities
        vim.lsp.config(server_name, server)
      end

      -- yayamlls: Flux-aware YAML LS (not Mason-managed, installed via AUR)
      -- only beats yamlls on Kubernetes manifests (apiVersion/kind schemas, Flux rendering)
      vim.lsp.config("yayamlls", {
        cmd = { "yayamlls" },
        filetypes = { "yaml" },
        root_dir = function(bufnr, on_dir)
          if is_k8s_manifest(bufnr) then
            on_dir(vim.fs.root(bufnr, { ".yayamlls.yaml", ".git" }))
          end
        end,
        capabilities = capabilities,
      })
      vim.lsp.enable("yayamlls")
    end,
  },

  -- cmdline tools and lsp servers
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    config = function(_, opts)
      require("mason").setup(opts)
      -- ensure some packages are installed
      -- see https://github.com/mason-org/mason.nvim/issues/1338
      local registry = require("mason-registry")

      local packages = {
        "ansible-lint",
        "lua-language-server",
        "markdownlint-cli2",
        "markdown-toc",
        "ruff",
        "rust-analyzer",
        "shellcheck",
        "stylua",
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
