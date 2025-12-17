-- https://github.com/stevearc/conform.nvim
-- if true then return {} end

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        javascript = { "biome" },
        typescript = { "biome" },
        jsonc = { "biome" },
        json = { "biome" },
      })

      -- Configuração adicional do formatador biome
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        biome = { require_cwd = true },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        javascriptreact = { "biomejs" },
        typescriptreact = { "biomejs" },
        javascript = { "biomejs" },
        typescript = { "biomejs" },
        jsonc = { "biomejs" },
        json = { "biomejs" },
      })
    end,
  },
}
