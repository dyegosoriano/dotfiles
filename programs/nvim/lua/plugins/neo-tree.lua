-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- if true then return {} end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        follow_current_file = {
          leave_dirs_open = false,
          enabled = true,
        },
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
