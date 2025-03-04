return {
  "nvim-telescope/telescope.nvim",
  enabled = true,
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    defaults = {
      file_ignore_patterns = { "node_modules/", "%.git/", "dist/", "%.jpeg", "%.jpg", "%.png", "%.jpg", "%.pdf", "%.ttf" },
      layout_strategy = "horizontal",
    },
  },
}
