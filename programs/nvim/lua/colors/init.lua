local M = {}

local active_theme = "andromeda"
local themes = {
  andromeda = "colors.andromeda",
  -- dracula = "colors.dracula",
  -- vesper = "colors.vesper",
}


M.setup = function()
  local theme = require(themes[active_theme])
  if theme and theme.setup then
    theme.setup()
  else
    vim.notify("Theme '" .. active_theme .. "' not found or missing setup function", vim.log.levels.ERROR)
  end
end

M.get_lualine_theme = function()
  local theme = require(themes[active_theme])
  if theme and theme.lualine then
    return theme.lualine()
  else
    vim.notify("Lualine theme for '" .. active_theme .. "' not found", vim.log.levels.WARN)
    return "auto"
  end
end

M.get_palette = function()
  local theme = require(themes[active_theme])
  if theme and theme.palette then
    return theme.palette()
  else
    vim.notify("Palette for '" .. active_theme .. "' not found", vim.log.levels.WARN)
    return {}
  end
end

M.switch_theme = function(theme_name)
  if themes[theme_name] then
    active_theme = theme_name
    M.setup()
    vim.notify("Switched to theme: " .. theme_name, vim.log.levels.INFO)
  else
    vim.notify("Theme '" .. theme_name .. "' not available", vim.log.levels.ERROR)
  end
end

M.get_available_themes = function()
  local theme_list = {}
  for name, _ in pairs(themes) do
    table.insert(theme_list, name)
  end
  return theme_list
end

return M
