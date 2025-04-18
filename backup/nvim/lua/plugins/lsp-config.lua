-- https://github.com/neovim/nvim-lspconfig
-- if true then return {} end

return {
  {
    -- Mason: Gerenciador de instalação de LSP, DAP, linters e formatadores
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    -- Mason-LSPConfig: Integração entre Mason e LSPConfig
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rome", "prismals", "tailwindcss" },
      })
    end,
  },
  {
    -- LSPConfig: Configuração principal dos servidores LSP
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Configura as capacidades do LSP com suporte a autocompletion
      -- local cmp_nvim_lsp = require("cmp_nvim_lsp")
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
      lspconfig.rome.setup({ capabilities = capabilities })
    end,
  },
}
