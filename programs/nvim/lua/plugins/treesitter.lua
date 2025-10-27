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
        highlight = { enable = true },
        indent = { enable = false },
        ensure_installed = {
          "markdown_inline",
          "javascript",
          "typescript",
          "markdown",
          "python",
          "query",
          "regex",
          "scss",
          "json",
          "bash",
          "yaml",
          "html",
          "vim",
          "tsx",
          "css",
          "lua",
        },
      })
    end
  }
}
