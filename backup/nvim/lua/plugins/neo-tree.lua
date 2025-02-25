return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
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
  },
}
