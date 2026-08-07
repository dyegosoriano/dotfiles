-- https://github.com/neovim/nvim-lspconfig
-- if true then return {} end

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = { icons = { package_uninstalled = "✗", package_installed = "✓", package_pending = "➜" } },
      ensure_installed = { "shfmt" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {},
        prismals = {},
        lua_ls = {},
        biome = {},
        gopls = {},
        pylsp = {},
      },
    },
  },
}
