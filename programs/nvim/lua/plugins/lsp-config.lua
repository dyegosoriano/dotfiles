-- https://github.com/neovim/nvim-lspconfig
-- if true then return {} end

return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    opts = {
      ensure_installed = {
        'docker_compose_language_service',
        'tailwindcss',
        'dockerls',
        'prismals',
        'lua_ls',
        'pylsp',
        'gopls',
        'ts_ls'
      },
    }
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )
      local lspconfig = require('lspconfig')

      -- Docker Compose
      lspconfig.pylsp.setup({ capabilities = capabilities, settings = { pylsp = { plugins = { pycodestyle = { maxLineLength = 100, ignore = { 'W391' } } } } } })
      lspconfig.gopls.setup({ capabilities = capabilities, settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } } })
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.prismals.setup({ capabilities = capabilities })

      -- Tailwind CSS
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        settings = {
          tailwindCSS = {
            classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
            lint = {
              recommendedVariantOrder = 'warning',
              invalidTailwindDirective = 'error',
              invalidConfigPath = 'error',
              invalidVariant = 'error',
              invalidScreen = 'error',
              cssConflict = 'warning',
              invalidApply = 'error',
            },
            validate = true
          }
        }
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
            diagnostics = { globals = { 'vim' } },
            runtime = { version = 'LuaJIT' },
            telemetry = { enable = false },
          },
        },
      })

      -- TypeScript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayEnumMemberValueHints = true,
              includeInlayParameterNameHints = 'all',
              includeInlayVariableTypeHints = true,
            }
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayEnumMemberValueHints = true,
              includeInlayParameterNameHints = 'all',
              includeInlayVariableTypeHints = true,
            }
          }
        },
        -- Desabilitar formatação do TypeScript LSP para evitar conflito com Biome
        on_attach = function(client, bufnr)
          client.server_capabilities.documentRangeFormattingProvider = false
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
    end,
  },
}
