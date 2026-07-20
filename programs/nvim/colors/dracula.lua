-- Dracula para Neovim — implementação local.
-- Paleta oficial: https://draculatheme.com/contribute
vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd.syntax("reset")
end

vim.g.colors_name = "dracula"
vim.o.background = "dark"

local c = {
  current_line = "#44475a",
  background = "#282a36",
  foreground = "#f8f8f2",
  selection = "#44475a",
  comment = "#6272a4",
  orange = "#ffb86c",
  purple = "#bd93f9",
  yellow = "#f1fa8c",
  green = "#50fa7b",
  blue = "#6272a4",
  cyan = "#8be9fd",
  pink = "#ff79c6",
  red = "#ff5555",
  none = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Interface
hi("StatusLine", { fg = c.foreground, bg = c.current_line })
hi("TabLineSel", { fg = c.foreground, bg = c.current_line })
hi("StatusLineNC", { fg = c.comment, bg = c.current_line })
hi("NormalFloat", { fg = c.foreground, bg = c.background })
hi("VertSplit", { fg = c.current_line, bg = c.background })
hi("FloatBorder", { fg = c.purple, bg = c.background })
hi("Pmenu", { fg = c.foreground, bg = c.current_line })
hi("Normal", { fg = c.foreground, bg = c.background })
hi("IncSearch", { fg = c.background, bg = c.orange })
hi("PmenuSel", { fg = c.background, bg = c.purple })
hi("TabLine", { fg = c.comment, bg = c.background })
hi("Search", { fg = c.background, bg = c.yellow })
hi("CursorLineNr", { fg = c.green, bold = true })
hi("MatchParen", { fg = c.orange, bold = true })
hi("NeoTreeDirectoryName", { fg = c.blue })
hi("NeoTreeDirectoryIcon", { fg = c.blue })
hi("CursorColumn", { bg = c.current_line })
hi("WinSeparator", { fg = c.current_line })
hi("Title", { fg = c.purple, bold = true })
hi("ColorColumn", { bg = c.current_line })
hi("NvimTreeFolderName", { fg = c.blue })
hi("NvimTreeFolderIcon", { fg = c.blue })
hi("CursorLine", { bg = c.current_line })
hi("Whitespace", { fg = c.current_line })
hi("SignColumn", { bg = c.background })
hi("NonText", { fg = c.current_line })
hi("Visual", { bg = c.selection })
hi("Directory", { fg = c.blue })
hi("LineNr", { fg = c.comment })

-- Sintaxe base
hi("Todo", { fg = c.cyan, bg = c.background, bold = true })
hi("Comment", { fg = c.comment, italic = true })
hi("Type", { fg = c.cyan, italic = true })
hi("Identifier", { fg = c.foreground })
hi("StorageClass", { fg = c.cyan })
hi("Conditional", { fg = c.pink })
hi("Character", { fg = c.yellow })
hi("Constant", { fg = c.purple })
hi("Structure", { fg = c.cyan })
hi("Statement", { fg = c.pink })
hi("Function", { fg = c.green })
hi("Boolean", { fg = c.purple })
hi("Operator", { fg = c.pink })
hi("String", { fg = c.yellow })
hi("Number", { fg = c.purple })
hi("Keyword", { fg = c.pink })
hi("Special", { fg = c.pink })
hi("PreProc", { fg = c.pink })
hi("Repeat", { fg = c.pink })
hi("Error", { fg = c.red })

-- Diagnósticos e LSP
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.purple })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.orange })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.cyan })
hi("LspReferenceWrite", { bg = c.current_line })
hi("LspReferenceText", { bg = c.current_line })
hi("LspReferenceRead", { bg = c.current_line })
hi("DiagnosticHint", { fg = c.purple })
hi("DiagnosticWarn", { fg = c.orange })
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticInfo", { fg = c.cyan })

-- Treesitter
hi("@tag.delimiter", { fg = c.foreground })
hi("@variable.builtin", { fg = c.purple })
hi("@keyword.function", { fg = c.pink })
hi("@function.call", { fg = c.green })
hi("@tag.attribute", { fg = c.green })
hi("@function", { link = "Function" })
hi("@variable", { fg = c.foreground })
hi("@keyword", { link = "Keyword" })
hi("@boolean", { link = "Boolean" })
hi("@comment", { link = "Comment" })
hi("@string", { link = "String" })
hi("@number", { link = "Number" })
hi("@property", { fg = c.cyan })
hi("@type", { link = "Type" })
hi("@tag", { fg = c.pink })

-- Git e diff
hi("DiffChange", { fg = c.orange, bg = c.background })
hi("DiffDelete", { fg = c.red, bg = c.background })
hi("DiffAdd", { fg = c.green, bg = c.background })
hi("GitSignsChange", { fg = c.orange })
hi("GitSignsDelete", { fg = c.red })
hi("GitSignsAdd", { fg = c.green })
