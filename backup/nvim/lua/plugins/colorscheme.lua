-- https://github.com/folke/tokyonight.nvim
if true then return {} end

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      styles = { sidebars = "transparent", floats = "transparent" },
      transparent = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
}
