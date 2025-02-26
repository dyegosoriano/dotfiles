return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  opts = {
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
    filesystem = {
      hijack_netrw_behavior = "open_default", -- Evita abrir automaticamente
      filtered_items = {
        never_show = { ".git", "node_modules", "dist" },
        always_show = { ".gitignore", ".env" },
        hide_gitignored = false,
        hide_dotfiles = false,
        hide_hidden = false,
        visible = true,
      },
    },
    event_handlers = {
      {
        event = "vim_buffer_enter",
        handler = function()
          require("neo-tree.command").execute({ action = "close" }) -- Garante que o Neo-tree não abra ao iniciar
        end,
      },
    },
  },
}
