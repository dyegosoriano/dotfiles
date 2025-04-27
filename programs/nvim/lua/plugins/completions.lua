-- https://github.com/hrsh7th/nvim-cmp
-- if true then return {} end

return {
  {
    "hrsh7th/cmp-nvim-lsp" -- Plugin para integração do LSP com o sistema de completação
  },
  {
    "L3MON4D3/LuaSnip", -- Engine de snippets em Lua com suporte a múltiplos formatos
    dependencies = {
      "rafamadriz/friendly-snippets", -- Coleção de snippets pré-definidos
      "saadparwaiz1/cmp_luasnip", -- Integração do LuaSnip com nvim-cmp
    },
  },
  {
    "hrsh7th/nvim-cmp", -- Plugin principal de auto completação para Neovim
    version = false, -- Desativa controle de versão para usar sempre a mais recente
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load() -- Carrega snippets do VSCode de forma lazy (sob demanda)

      cmp.setup({
        -- Configuração do engine de snippets
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        -- Estilização das janelas de completação e documentação
        window = {
          documentation = cmp.config.window.bordered(), -- Adiciona bordas à janela de documentação
          completion = cmp.config.window.bordered(), -- Adiciona bordas à janela de completação
        },

        -- Mapeamento de teclas para controle da completação
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirma seleção
          ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Rola documentação para cima
          ["<C-f>"] = cmp.mapping.scroll_docs(4),  -- Rola documentação para baixo
          ["<C-Space>"] = cmp.mapping.complete(),  -- Abre menu de completação
          ["<C-e>"] = cmp.mapping.abort(),        -- Fecha menu de completação
        }),

        -- Fontes de completação em ordem de prioridade
        sources = cmp.config.sources({
          { name = "luasnip" },  -- Completação de snippets
          { name = "nvim_lsp" }, -- Completação do LSP
        }, {
          { name = "buffer" },   -- Completação baseada no buffer atual
        }),
      })
    end,
  },
}
