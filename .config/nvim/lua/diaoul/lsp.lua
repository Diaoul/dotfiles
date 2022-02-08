local M = {}


function M.setup()
    -- gutter signs
    local signs = {
        Error = " ",  --   ◉
        Warn = " ",   --    ●  𥉉
        Info = " ",   --   •  
        Hint = " ",   --       𥉉
    }

    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config({
        float = {
            source = 'always',
        },
        update_in_insert = true,
        severity_sort = true,
        -- virtual_text = {
        --     prefix = '●', -- ■ ● ▎x
        -- },
    })
end

function M.config()
  local lspconfig = require('lspconfig')

  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- common mappings
    local opts = { noremap = true, silent = true }

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
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>', opts)
    -- formatting
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    if client.resolved_capabilities.document_highlight then
      vim.cmd [[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]]
    end
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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
