-- https://github.com/neovim/nvim-lspconfig
-- if true then return {} end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    -- opts = { auto_install = true },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "biome", "prismals", "tailwindcss" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities()
        -- cmp_nvim_lsp.default_capabilities()
      )

      local lspconfig = require("lspconfig")

      -- Configuração dos servidores LSP
      lspconfig.tailwindcss.setup({ capabilities = capabilities })
      lspconfig.prismals.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.biome.setup({ capabilities = capabilities })
    end,
  },
}
