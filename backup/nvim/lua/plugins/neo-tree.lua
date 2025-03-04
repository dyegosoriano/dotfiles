return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          never_show = { ".git", "node_modules", "dist" },
          always_show = { ".gitignore", ".env" },
          hide_gitignored = false,
          hide_dotfiles = false,
          hide_hidden = false,
          visible = true,
        },
      },
    })
  end,
}
