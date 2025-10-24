local lualine_highlights = require("colors.vesper.lualine-highlights")
local highlights = require("colors.vesper.highlights")
local palette = require("colors.vesper.palette")

local M = {}

M.setup = function()
  highlights.setup()
end

M.lualine = function()
  return lualine_highlights
end

M.palette = function()
  return palette
end

return M
