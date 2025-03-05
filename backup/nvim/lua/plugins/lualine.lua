return {
  "nvim-lualine/lualine.nvim",
  enabled = false,
  config = function()
    require('lualine').setup({
      options = {
        theme = 'dracula'
      }
    })
  end
}
