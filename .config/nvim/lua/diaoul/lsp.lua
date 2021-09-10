local M = {}

function M.config()
  local lspconfig = require('lspconfig')

  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- omni completion
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- common mappings
    local opts = { noremap=true, silent=true }

    -- navigation
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- workspaces
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- diagnostics
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    -- formatting
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  -- YAML
  lspconfig.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      yaml = {
        customTags = {
          -- Home Assistant
          '!secret',
          '!include_dir_named',
          '!include_dir_list',
          '!include_dir_merge_named',
          '!include_dir_merge_list',
          '!lambda',
          '!input',
        },
      },
    },
  }

  -- Python
  lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Docker
  lspconfig.dockerls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Go
  lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Typescript
  lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Rust
  lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- C / C++
  lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Elixir
  lspconfig.elixirls.setup{
    cmd = { "/usr/bin/elixir-ls" };
    on_attach = on_attach,
    capabilities = capabilities,
  }


  -- Lua
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")
  lspconfig.sumneko_lua.setup {
    cmd = {'/usr/bin/lua-language-server'};
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
          runtime = {
              version = 'LuaJIT',
              path = runtime_path,
          },
          diagnostics = {
              globals = {'vim'},
          },
          workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              preloadFileSize = 500,
         },
        telemetry = {
            enable = false,
         },
      },
    },
  }

  -- map :Format to vim.lsp.buf.formatting()
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

return M
