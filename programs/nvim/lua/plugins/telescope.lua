-- https://github.com/nvim-telescope/telescope.nvim
-- if true then return {} end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    pickers = { find_files = {} },
    defaults = {
      file_ignore_patterns = { 'node_modules/', '%.git/', 'dist/', '%.jpeg', '%.jpg', '%.png', '%.jpg', '%.pdf', '%.ttf' },
      buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
      layout_strategy = 'horizontal',
    },
  },
}
