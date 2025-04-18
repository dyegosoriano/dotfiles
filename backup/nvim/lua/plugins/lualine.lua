-- https://github.com/nvim-lualine/lualine.nvim
-- if true then return {} end

local colors = {
  turquoise_blue = '#00BFA5',
  orange = '#FF6F00',
  purple = '#651FFF',
  black = '#1F1F1F',
  white = '#f3f3f3',
  green = '#76FF03',
  gray = '#6C6F93',
  red = '#F50057',

  transparent = nil,
}

local theme = {
  inactive = {
    a = { fg = colors.gray, bg = colors.transparent },
    b = { fg = colors.gray, bg = colors.transparent },
    c = { fg = colors.gray, bg = colors.transparent },
  },
  visual = {
    a = { fg = colors.black, bg = colors.gray },
    b = { fg = colors.white, bg = colors.purple },
    c = { fg = colors.white, bg = colors.transparent },
  },
  replace = {
    a = { fg = colors.black, bg = colors.orange },
    b = { fg = colors.white, bg = colors.purple },
    c = { fg = colors.white, bg = colors.transparent },
  },
  normal = {
      a = { fg = colors.black, bg = colors.green },
      b = { fg = colors.white, bg = colors.purple },
      c = { fg = colors.white, bg = colors.transparent },
  },
  insert = {
      a = { fg = colors.black, bg = colors.red },
      b = { fg = colors.white, bg = colors.purple },
      c = { fg = colors.white, bg = colors.transparent },
  },
  command = {
      a = { fg = colors.black, bg = colors.turquoise_blue },
      b = { fg = colors.white, bg = colors.purple },
      c = { fg = colors.white, bg = colors.transparent },
  }
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = theme,
      }
    })
  end
}
