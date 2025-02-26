return {
  "nvim-telescope/telescope.nvim",
  enabled = true,
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    defaults = {
      file_ignore_patterns = { "node_modules/", "%.git/", "dist/", "%.jpeg", "%.jpg", "%.png", "%.jpg", "%.pdf" },
      layout_strategy = "horizontal",
    },
  },
  keys = {
    { "<leader>fn", "<cmd>Telescope notify<cr>",  desc = "Buscar notificações" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar Arquivos" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers Abertos" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Buscar Texto" },
  },
}
