local colors = require("colors.andromeda.palette")

local M = {
  normal = {
    a = { fg = colors.background, bg = colors.blue, gui = "bold" },
    b = { fg = colors.green, bg = colors.mono_2 },
    c = { fg = colors.mono_5, bg = colors.mono_1 },
    x = { fg = colors.mono_5, bg = colors.mono_1 },
    y = { fg = colors.mono_5, bg = colors.mono_1 },
    z = { fg = colors.mono_6, bg = colors.mono_1 },
  },
  insert = {
    a = { fg = colors.background, bg = colors.cyan, gui = "bold" },
    b = { fg = colors.green, bg = colors.mono_2 },
    c = { fg = colors.mono_5, bg = colors.mono_1 },
    x = { fg = colors.mono_5, bg = colors.mono_1 },
    y = { fg = colors.mono_5, bg = colors.mono_1 },
    z = { fg = colors.mono_6, bg = colors.mono_1 },
  },
  visual = {
    a = { fg = colors.background, bg = colors.green, gui = "bold" },
    b = { fg = colors.green, bg = colors.mono_2 },
    c = { fg = colors.mono_5, bg = colors.mono_1 },
    x = { fg = colors.mono_5, bg = colors.mono_1 },
    y = { fg = colors.mono_5, bg = colors.mono_1 },
    z = { fg = colors.mono_6, bg = colors.mono_1 },
  },
  replace = {
    a = { fg = colors.background, bg = colors.orange, gui = "bold" },
    b = { fg = colors.green, bg = colors.mono_2 },
    c = { fg = colors.mono_5, bg = colors.mono_1 },
    x = { fg = colors.mono_5, bg = colors.mono_1 },
    y = { fg = colors.mono_5, bg = colors.mono_1 },
    z = { fg = colors.mono_6, bg = colors.mono_1 },
  },
  command = {
    a = { fg = colors.background, bg = colors.hot_pink, gui = "bold" },
    b = { fg = colors.green, bg = colors.mono_2 },
    c = { fg = colors.mono_5, bg = colors.mono_1 },
    x = { fg = colors.mono_5, bg = colors.mono_1 },
    y = { fg = colors.mono_5, bg = colors.mono_1 },
    z = { fg = colors.mono_6, bg = colors.mono_1 },
  },
  terminal = {
    a = { fg = colors.background, bg = colors.hot_pink, gui = "bold" },
    b = { fg = colors.green, bg = colors.mono_2 },
    c = { fg = colors.mono_5, bg = colors.mono_1 },
    x = { fg = colors.mono_5, bg = colors.mono_1 },
    y = { fg = colors.mono_5, bg = colors.mono_1 },
    z = { fg = colors.hot_pink, bg = colors.mono_1 },
  },
  inactive = {
    a = { fg = colors.background, bg = colors.background },
    b = { fg = colors.background, bg = colors.background },
    c = { fg = colors.background, bg = colors.background },
  },
}

return M
