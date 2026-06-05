-- https://github.com/neovim/nvim-lspconfig
-- if true then return {} end

return {
  {
    'mason-org/mason.nvim',
    opts = {
      ui = { icons = { package_uninstalled = '✗', package_installed = '✓', package_pending = '➜' } },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tailwindcss = {},
        lua_ls = {},
        ts_ls = {},
        gopls = {},
        pylsp = {},
      },
    },
  },
}
