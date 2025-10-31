-- https://github.com/neovim/nvim-lspconfig
-- if true then return {} end

return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup({
        ui = { icons = { package_uninstalled = '✗', package_installed = '✓', package_pending = '➜' } }
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    config = function()
      require('mason-lspconfig').setup({
        automatic_installation = true,
        ensure_installed = {
          'tailwindcss',
          'lua_ls',
          'ts_ls',
          'gopls',
          'pylsp',
        },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      'nvimtools/none-ls.nvim',
      'hrsh7th/nvim-cmp', -- Adiciona nvim-cmp como dependência
    },
    config = function()
      -- Aguarda o nvim-cmp estar disponível
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )
      local lspconfig = require('lspconfig')

      -- Função on_attach compartilhada para desabilitar formatação quando none-ls estiver ativo
      local on_attach = function(client, bufnr)
        -- Desabilita formatação do LSP para evitar conflito com none-ls
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.documentFormattingProvider = false
      end

      lspconfig.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.lua_ls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.ts_ls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.gopls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.pylsp.setup({ capabilities = capabilities, on_attach = on_attach })
    end,
  },
}
