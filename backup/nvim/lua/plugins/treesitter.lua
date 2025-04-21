-- https://github.com/nvim-treesitter/nvim-treesitter
-- if true then return {} end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = false, -- TODO: Identificar do que se trata esse ajuste.
        ensure_installed = {
          "javascript",
          "typescript",
          "scss",
          "json",
          "bash",
          "html",
          "css",
          "lua",
        },
        highlight = { enable = true },
        indent = { enable = false },
      })
    end
  }
}
