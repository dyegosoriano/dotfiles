-- https://github.com/nvim-lualine/lualine.nvim
-- if true then return {} end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        -- component_separators = { left = '>', right = '<' },
        -- section_separators = { left = '', right = '' },
        -- theme = colors_manager.get_lualine_theme(),
        icons_enabled = true,
        theme = 'auto',
      }
    })
  end
}
