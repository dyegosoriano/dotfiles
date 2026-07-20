-- Vesper para Neovim — implementação local, sem dependências externas.
vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd.syntax("reset")
end

vim.g.colors_name = "vesper"
vim.o.background = "dark"

local c = {
  selection = "#282828",
  surface = "#1e1e1e",
  orange = "#ffc799",
  yellow = "#ffee99",
  purple = "#d2a6ff",
  green = "#99ffe4",
  muted = "#a0a0a0",
  blue = "#a0c8ff",
  pink = "#ff99cc",
  red = "#ff8080",
  bg = "#101010",
  fg = "#ffffff",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Interface
hi("StatusLineNC", { fg = c.muted, bg = c.surface })
hi("CursorLineNr", { fg = c.yellow, bold = true })
hi("MatchParen", { fg = c.orange, bold = true })
hi("StatusLine", { fg = c.fg, bg = c.surface })
hi("VertSplit", { fg = c.surface, bg = c.bg })
hi("FloatBorder", { fg = c.blue, bg = c.bg })
hi("IncSearch", { fg = c.bg, bg = c.orange })
hi("NeoTreeDirectoryName", { fg = c.blue })
hi("NeoTreeDirectoryIcon", { fg = c.blue })
hi("NormalFloat", { fg = c.fg, bg = c.bg })
hi("Title", { fg = c.purple, bold = true })
hi("PmenuSel", { fg = c.bg, bg = c.blue })
hi("Search", { fg = c.bg, bg = c.yellow })
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
hi("Type", { fg = c.yellow, italic = true })
hi("Todo", { fg = c.blue, bold = true })
hi("StorageClass", { fg = c.yellow })
hi("Conditional", { fg = c.pink })
hi("Structure", { fg = c.yellow })
hi("Character", { fg = c.green })
hi("Constant", { fg = c.purple })
hi("Statement", { fg = c.pink })
hi("Boolean", { fg = c.purple })
hi("Special", { fg = c.orange })
hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.blue })
hi("Operator", { fg = c.pink })
hi("Number", { fg = c.purple })
hi("PreProc", { fg = c.pink })
hi("Keyword", { fg = c.pink })
hi("String", { fg = c.green })
hi("Repeat", { fg = c.pink })
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
hi("DiagnosticHint", { fg = c.purple })
hi("DiagnosticWarn", { fg = c.orange })
hi("@function", { link = "Function" })
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticInfo", { fg = c.blue })
hi("@function.call", { fg = c.blue })
hi("@tag.attribute", { fg = c.blue })
hi("@comment", { link = "Comment" })
hi("@boolean", { link = "Boolean" })
hi("@keyword", { link = "Keyword" })
hi("@property", { fg = c.yellow })
hi("@string", { link = "String" })
hi("@number", { link = "Number" })
hi("@variable", { fg = c.fg })
hi("@type", { link = "Type" })
hi("@tag", { fg = c.pink })

-- Git e diff
hi("DiffChange", { fg = c.orange, bg = c.bg })
hi("DiffDelete", { fg = c.red, bg = c.bg })
hi("DiffAdd", { fg = c.green, bg = c.bg })
hi("GitSignsChange", { fg = c.orange })
hi("GitSignsDelete", { fg = c.red })
hi("GitSignsAdd", { fg = c.green })
