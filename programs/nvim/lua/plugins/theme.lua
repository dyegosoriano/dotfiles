-- Selecione aqui: "dracula", "vesper", "aura" ou "catppuccin".
local colorscheme = "aura"

return {
  {
    name = "local-colorschemes",
    dir = vim.fn.stdpath("config"),
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme(colorscheme)
    end,
  },
}
