-- https://github.com/akinsho/bufferline.nvim
-- if true then return {} end

return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup({
      options = {
        indicator = { icon = '▎', style = 'icon' },
        offsets = {
          {
            highlight = "Directory",
            text = "File Explorer",
            filetype = "neo-tree",
            text_align = "center"
          }
        }
      }
    })
  end,
}
