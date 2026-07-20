-- Aura para Neovim — implementação local, sem dependências externas.
vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd.syntax("reset")
end

vim.g.colors_name = "aura"
vim.o.background = "dark"

local c = {
  selection = "#292735",
  surface = "#1c1b22",
  yellow = "#f7d08a",
  orange = "#ffca85",
  purple = "#a277ff",
  muted = "#6d6d6d",
  green = "#61ffca",
  pink = "#ff9e64",
  blue = "#82e2ff",
  red = "#ff6767",
  bg = "#15141b",
  fg = "#edecee",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Interface
hi("StatusLineNC", { fg = c.muted, bg = c.surface })
hi("CursorLineNr", { fg = c.orange, bold = true })
hi("MatchParen", { fg = c.orange, bold = true })
hi("FloatBorder", { fg = c.purple, bg = c.bg })
hi("StatusLine", { fg = c.fg, bg = c.surface })
hi("VertSplit", { fg = c.surface, bg = c.bg })
hi("IncSearch", { fg = c.bg, bg = c.purple })
hi("PmenuSel", { fg = c.bg, bg = c.purple })
hi("NeoTreeDirectoryName", { fg = c.blue })
hi("NeoTreeDirectoryIcon", { fg = c.blue })
hi("NormalFloat", { fg = c.fg, bg = c.bg })
hi("Title", { fg = c.purple, bold = true })
hi("Search", { fg = c.bg, bg = c.orange })
hi("Pmenu", { fg = c.fg, bg = c.surface })
hi("NvimTreeFolderName", { fg = c.blue })
hi("NvimTreeFolderIcon", { fg = c.blue })
hi("WinSeparator", { fg = c.surface })
hi("CursorColumn", { bg = c.surface })
hi("Normal", { fg = c.fg, bg = c.bg })
hi("ColorColumn", { bg = c.surface })
hi("Whitespace", { fg = c.surface })
hi("CursorLine", { bg = c.surface })
hi("Visual", { bg = c.selection })
hi("NonText", { fg = c.surface })
hi("Directory", { fg = c.blue })
hi("SignColumn", { bg = c.bg })
hi("LineNr", { fg = c.muted })

-- Sintaxe
hi("Comment", { fg = c.muted, italic = true })
hi("Type", { fg = c.orange, italic = true })
hi("Todo", { fg = c.blue, bold = true })
hi("StorageClass", { fg = c.orange })
hi("Conditional", { fg = c.purple })
hi("Statement", { fg = c.purple })
hi("Structure", { fg = c.orange })
hi("Constant", { fg = c.purple })
hi("Character", { fg = c.green })
hi("Boolean", { fg = c.purple })
hi("Keyword", { fg = c.purple })
hi("PreProc", { fg = c.purple })
hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.blue })
hi("Operator", { fg = c.pink })
hi("Number", { fg = c.purple })
hi("Repeat", { fg = c.purple })
hi("String", { fg = c.green })
hi("Special", { fg = c.pink })
hi("Error", { fg = c.red })

-- Diagnósticos, LSP e Treesitter
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.orange })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.purple })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
hi("LspReferenceWrite", { bg = c.surface })
hi("@variable.builtin", { fg = c.purple })
hi("LspReferenceText", { bg = c.surface })
hi("LspReferenceRead", { bg = c.surface })
hi("DiagnosticWarn", { fg = c.orange })
hi("DiagnosticHint", { fg = c.purple })
hi("@function", { link = "Function" })
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticInfo", { fg = c.blue })
hi("@function.call", { fg = c.blue })
hi("@tag.attribute", { fg = c.blue })
hi("@boolean", { link = "Boolean" })
hi("@keyword", { link = "Keyword" })
hi("@comment", { link = "Comment" })
hi("@property", { fg = c.orange })
hi("@string", { link = "String" })
hi("@number", { link = "Number" })
hi("@variable", { fg = c.fg })
hi("@type", { link = "Type" })
hi("@tag", { fg = c.purple })

-- Git e diff
hi("DiffChange", { fg = c.orange, bg = c.bg })
hi("DiffDelete", { fg = c.red, bg = c.bg })
hi("DiffAdd", { fg = c.green, bg = c.bg })
hi("GitSignsChange", { fg = c.orange })
hi("GitSignsDelete", { fg = c.red })
hi("GitSignsAdd", { fg = c.green })
