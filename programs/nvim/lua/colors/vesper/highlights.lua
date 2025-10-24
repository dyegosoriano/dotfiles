local colors = require("colors.vesper.palette")

local M = {}

M.setup = function()
  -- Set background
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.foreground, bg = colors.background })
  vim.api.nvim_set_hl(0, "NormalNC", { fg = colors.foreground, bg = colors.background })
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.background, bg = colors.background })

  -- Semantic Highlighting
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.error, bg = nil, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.hint, bg = nil, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.info, bg = nil, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.warn, bg = nil, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = colors.error })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = colors.warn })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = colors.hint })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = colors.info })

  -- Git
  vim.api.nvim_set_hl(0, "DiffChange", { fg = colors.diff_change, bg = colors.background })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = colors.diff_delete, bg = colors.background })
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = colors.diff_add, bg = colors.background })

  -- Telescope
  vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = colors.secondary, bg = colors.mono_3, bold = true })
  vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { fg = colors.foreground, bg = colors.background })
  vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = colors.secondary, bg = colors.background })
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = colors.foreground, bg = colors.background })
  vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { fg = colors.mono_6, bg = colors.background })
  vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = colors.secondary, bg = colors.background })
  vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = colors.secondary, bg = colors.background })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.mono_3, bg = colors.background })

  -- Notify
  vim.api.nvim_set_hl(0, "NotifyERRORBody", { fg = colors.foreground, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = colors.error, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = colors.error, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = colors.error, bg = colors.background })

  vim.api.nvim_set_hl(0, "NotifyWARNBody", { fg = colors.foreground, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = colors.warn, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = colors.warn, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = colors.warn, bg = colors.background })

  vim.api.nvim_set_hl(0, "NotifyINFOBody", { fg = colors.foreground, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = colors.info, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = colors.info, bg = colors.background })
  vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = colors.info, bg = colors.background })
end

return M
