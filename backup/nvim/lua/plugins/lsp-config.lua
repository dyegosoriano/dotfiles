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

      -- Atalhos de teclado para funcionalidades LSP
      -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {}) -- Mostra documentação ao passar o cursor
      -- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {}) -- Vai para a definição
      -- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {}) -- Mostra referências
      -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {}) -- Ações de código
      -- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {}) -- Formata o código
      -- vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {}) -- Renomeia símbolos
    end,
  },
}
