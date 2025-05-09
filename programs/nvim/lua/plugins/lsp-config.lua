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
        ensure_installed = { "docker_compose_language_service", "tailwindcss", "dockerls", "prismals", "pylsp", "gopls", "lua_ls", "ts_ls" },
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
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      local lspconfig = require("lspconfig")
      -- Documentação com todos os LSP
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

      -- Configuração dos servidores LSP
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities, filetypes = { "yaml.docker-compose" } })
      lspconfig.gopls.setup({ capabilities = capabilities, filetypes = { "go", "gomod", "gowork", "gotmpl" } })
      lspconfig.dockerls.setup({ capabilities = capabilities, filetypes = { "dockerfile" } })
      lspconfig.prismals.setup({ capabilities = capabilities, filetypes = { "prisma" } })
      lspconfig.pylsp.setup({ capabilities = capabilities, filetypes = { "python" } })
      lspconfig.tailwindcss.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.ts_ls.setup({ capabilities = capabilities })
    end,
  },
}
