-- https://github.com/hrsh7th/nvim-cmp
-- if true then return {} end

return {
  { "hrsh7th/cmp-nvim-lsp" },         -- Plugin para integração do LSP com o sistema de completação
  { "hrsh7th/cmp-cmdline" },          -- Completação para linha de comando
  { "hrsh7th/cmp-buffer" },           -- Completação baseada no buffer
  { "hrsh7th/cmp-path" },             -- Completação de caminhos de arquivos
  {
    "L3MON4D3/LuaSnip",               -- Engine de snippets em Lua com suporte a múltiplos formatos
    dependencies = {
      "rafamadriz/friendly-snippets", -- Coleção de snippets pré-definidos
      "saadparwaiz1/cmp_luasnip",     -- Integração do LuaSnip com nvim-cmp
    },
  },
  {
    "hrsh7th/nvim-cmp", -- Plugin principal de auto completação para Neovim
    version = false,    -- Desativa controle de versão para usar sempre a mais recente
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      require("luasnip.loaders.from_vscode").lazy_load() -- Carrega snippets do VSCode de forma lazy (sob demanda)

      cmp.setup({
        -- Configuração do engine de snippets
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Estilização das janelas de completação e documentação
        window = {
          documentation = cmp.config.window.bordered(), -- Adiciona bordas à janela de documentação
          completion = cmp.config.window.bordered(),    -- Adiciona bordas à janela de completação
        },

        -- Mapeamento de teclas para controle da completação
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }), -- Confirma seleção
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),                                                   -- Rola documentação para cima
          ["<C-f>"] = cmp.mapping.scroll_docs(4),                                                    -- Rola documentação para baixo
          ["<C-Space>"] = cmp.mapping.complete(),                                                    -- Abre menu de completação
          ["<C-e>"] = cmp.mapping.abort(),                                                           -- Fecha menu de completação

          -- Navegação com Tab e Shift-Tab
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Formatação dos itens de completação
        formatting = {
          format = function(entry, vim_item)
            -- Ícones para diferentes tipos de completação
            local icons = {
              TypeParameter = "",
              Constructor = "",
              EnumMember = "",
              Reference = "󰈇",
              Operator = "󰆕",
              Function = "󰊕",
              Variable = "󰀫",
              Interface = "",
              Property = "󰜢",
              Constant = "󰏿",
              Keyword = "󰌋",
              Folder = "󰉋",
              Snippet = "",
              Method = "󰆧",
              Struct = "󰙅",
              Class = "󰠱",
              Field = "󰜢",
              Color = "󰏘",
              Module = "",
              Value = "󰎠",
              Event = "",
              File = "󰈙",
              Unit = "󰑭",
              Text = "󰉿",
              Enum = "",
            }

            vim_item.kind = string.format('%s %s', icons[vim_item.kind] or "", vim_item.kind)
            vim_item.menu = ({
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              path = "[Path]",
            })[entry.source.name]

            return vim_item
          end,
        },

        -- Fontes de completação em ordem de prioridade
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 }, -- Completação do LSP (prioridade alta)
          { name = "luasnip",  priority = 750 },  -- Completação de snippets
          { name = "buffer",   priority = 500 },  -- Completação baseada no buffer atual
          { name = "path",     priority = 250 },  -- Completação de caminhos
        }),

        -- Configurações experimentais
        experimental = {
          ghost_text = true, -- Mostra preview do texto que será inserido
        },
      })

      -- Completação para pesquisa (/)
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } }
      })

      -- Completação para linha de comando (:)
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end,
  },
}
