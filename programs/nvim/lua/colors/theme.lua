local M = {}

local colors = require("colors.andromeda")

M.setup = function()
  -- Vim Editor
  vim.api.nvim_set_hl(0, "InvNormal", { fg = colors.mono_2, bg = colors.background })
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.mono_5, bg = colors.background })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.mono_6 })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.mono_3 })

  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.mono_3, bg = colors.background })
  vim.api.nvim_set_hl(0, "SignColumn", { fg = nil, bg = colors.background })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = colors.mono_3, bg = nil })
  -- vim.api.nvim_set_hl(0, "VertSplit",   { g.FloatBorder, g.FloatBorder })

  vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.diagnostic_warning })
  vim.api.nvim_set_hl(0, "ErrorMsg", { fg = colors.diagnostic_error })
  vim.api.nvim_set_hl(0, "MoreMsg", { fg = colors.diagnostic_info })

  -- Cursor
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.mono_6, bg = colors.mono_1 })
  vim.api.nvim_set_hl(0, "CursorColumn", { fg = nil, bg = colors.mono_1 })
  vim.api.nvim_set_hl(0, "CursorLine", { fg = nil, bg = colors.mono_1 })
  vim.api.nvim_set_hl(0, "Cursor", { fg = nil })

  -- Files
  vim.api.nvim_set_hl(0, "Directory", { fg = colors.primary })

  -- Search
  vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.mono_1, bg = colors.orange })
  vim.api.nvim_set_hl(0, "Search", { fg = colors.mono_1, bg = colors.blue })

  -- Visual
  vim.api.nvim_set_hl(0, "Visual", { fg = nil, bg = colors.mono_2 })
  -- vim.api.nvim_set_hl(0, "VisualLineMode",  { g.Visual, g.Visual })
  -- vim.api.nvim_set_hl(0, "VisualMode",      { g.Visual, g.Visual })

  -- Popup Menu
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.primary, bg = colors.mono_2 })
  vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.mono_6, bg = colors.mono_1 })
  vim.api.nvim_set_hl(0, "PmenuThumb", { fg = nil, bg = colors.mono_2 })
  vim.api.nvim_set_hl(0, "PmenuSbar", { fg = nil, bg = colors.mono_1 })
  vim.api.nvim_set_hl(0, "Title", { fg = colors.primary })

  -- TabLine
  vim.api.nvim_set_hl(0, "TabLineFill", { fg = nil, bg = colors.mono_2 })
  vim.api.nvim_set_hl(0, "TabLine", { fg = colors.mono_5, bg = colors.mono_2 })
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.mono_6, bg = nil })

  -- StatusLine
  -- Disabled due to: https://github.com/vim/vim/issues/13366#issuecomment-1790617530
  -- vim.api.nvim_set_hl(0, "StatusLineNC",  { fg = colors.mono_3, bg = colors.mono_2 })
  -- vim.api.nvim_set_hl(0, "StatusLine",    { fg = colors.mono_3, bg = colors.mono_2 })

  -- Standard Syntax
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.mono_5, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "Special", { fg = colors.cyan, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "Question", { fg = colors.mono_6, bg = colors.mono_2 })
  vim.api.nvim_set_hl(0, "Folded", { fg = colors.mono_3, bg = colors.mono_2 })
  vim.api.nvim_set_hl(0, "MatchParen", { fg = colors.mono_6, bg = nil })
  vim.api.nvim_set_hl(0, "SpecialKey", { fg = colors.pink, bg = nil })
  vim.api.nvim_set_hl(0, "NonText", { fg = colors.mono_1, bg = nil })
  vim.api.nvim_set_hl(0, "SpellLocal", { fg = colors.mono_3 })
  vim.api.nvim_set_hl(0, "Character", { fg = colors.mono_5 })
  vim.api.nvim_set_hl(0, "Statement", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "SpellCap", { fg = colors.mono_6 })
  vim.api.nvim_set_hl(0, "Conceal", { fg = colors.mono_5 })
  vim.api.nvim_set_hl(0, "PreProc", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.orange })
  vim.api.nvim_set_hl(0, "Label", { fg = colors.mono_3 })
  vim.api.nvim_set_hl(0, "Type", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "Identifier", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "SpellRare", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "Constant", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "SpellBad", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "Error", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "Todo", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "Boolean", { fg = colors.red })

  -- Treesitter Syntax Highlighting
  -- See :help treesitter-highlight-groups
  vim.api.nvim_set_hl(0, "@keyword.function", { fg = colors.purple, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@keyword.operator", { fg = colors.red, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@keyword.return", { fg = colors.purple, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@conditional", { fg = colors.purple, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@operator", { fg = colors.red, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@include", { fg = colors.purple, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@keyword", { fg = colors.purple, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@comment", { fg = colors.mono_5, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@preproc", { fg = colors.mono_5, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@define", { fg = colors.purple, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@repeat", { fg = colors.purple, bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "@tag.attribute", { fg = colors.hot_pink })
  vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = colors.hot_pink })
  vim.api.nvim_set_hl(0, "@text.todo", { fg = colors.hot_pink })
  vim.api.nvim_set_hl(0, "@debug", { fg = colors.hot_pink })
  vim.api.nvim_set_hl(0, "@tag", { fg = colors.hot_pink })
  vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = colors.mono_6 })
  vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@function.builtin", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@type.definition", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "@function.macro", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@function.call", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@storageclass", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "@type.builtin", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@punctuation", { fg = colors.mono_6 })
  vim.api.nvim_set_hl(0, "@constructor", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@method.call", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@identifier", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@exception", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "@text.uri", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "@function", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@method", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@number", { fg = colors.orange })
  vim.api.nvim_set_hl(0, "@float", { fg = colors.orange })
  vim.api.nvim_set_hl(0, "@type", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "@text.underline", { fg = colors.green })
  vim.api.nvim_set_hl(0, "@string.escape", { fg = colors.green })
  vim.api.nvim_set_hl(0, "@text.literal", { fg = colors.green })
  vim.api.nvim_set_hl(0, "@string", { fg = colors.green })
  vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "@constant.macro", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "@string.regexp", { fg = colors.blue })
  vim.api.nvim_set_hl(0, "@text.title", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "@structure", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "@variable", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "@namespace", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "@parameter", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "@property", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "@field", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "@label", { fg = colors.cyan })
  vim.api.nvim_set_hl(0, "@macro", { fg = colors.pink })
  vim.api.nvim_set_hl(0, "@punctuation.special", { fg = colors.red })
  vim.api.nvim_set_hl(0, "@character.special", { fg = colors.red })
  vim.api.nvim_set_hl(0, "@constant.builtin", { fg = colors.red })
  vim.api.nvim_set_hl(0, "@text.reference", { fg = colors.red })
  vim.api.nvim_set_hl(0, "@string.special", { fg = colors.red })
  vim.api.nvim_set_hl(0, "@character", { fg = colors.red })
  vim.api.nvim_set_hl(0, "@constant", { fg = colors.red })
  vim.api.nvim_set_hl(0, "@boolean", { fg = colors.red })
  vim.api.nvim_set_hl(0, "@none", { fg = colors.red })

  -- Semantic Highlighting
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.diagnostic_error, bg = nil, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.diagnostic_hint, bg = nil, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.diagnostic_info, bg = nil, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.diagnostic_warning, bg = nil, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = colors.diagnostic_warning })
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = colors.diagnostic_error })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = colors.diagnostic_hint })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = colors.diagnostic_info })

  -- Git
  vim.api.nvim_set_hl(0, "DiffChange", { fg = colors.diff_change })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = colors.diff_delete })
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = colors.diff_add })
  -- vim.api.nvim_set_hl(0, "SignifySignChange", { g.DiffChange })
  -- vim.api.nvim_set_hl(0, "SignifySignDelete", { g.DiffDelete })
  -- vim.api.nvim_set_hl(0, "SignifySignAdd",    { g.DiffAdd })

  vim.api.nvim_set_hl(0, "DiffText", { fg = colors.mono_4, bg = colors.mono_1 })
  -- vim.api.nvim_set_hl(0, "GitBlameMsg",               { g.DiffText, g.DiffText })
  -- vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame",  { g.DiffText, g.DiffText })

  -- Telescope
  vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = colors.primary })
  vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = colors.primary })
  vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = colors.mono_3 })
  vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { fg = colors.mono_5 })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.mono_3 })

  -- Notify
  vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = colors.notify_error })
  vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = colors.notify_error })
  vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = colors.notify_error })

  vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = colors.notify_warning })
  vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = colors.notify_warning })
  vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = colors.notify_warning })

  vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = colors.notify_info })
  vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = colors.notify_info })
  vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = colors.notify_info })

  vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = colors.notify_debug })
  vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = colors.notify_debug })
  vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = colors.notify_debug })

  vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = colors.notify_trace })
  vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = colors.notify_trace })
  vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = colors.notify_trace })
end

return M
