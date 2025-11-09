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
        ensure_installed = { 'tailwindcss', 'lua_ls', 'ts_ls', 'gopls', 'pylsp' },
        automatic_installation = true,
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = { 'nvimtools/none-ls.nvim', 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      local lspconfig = require('lspconfig')

      lspconfig.tailwindcss.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.pylsp.setup({ capabilities = capabilities })

      -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
      -- vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
      -- vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
      -- vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
      -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, {})
      -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    end,
  },
}
