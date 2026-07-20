-- Catppuccin Mocha para Neovim — implementação local, sem dependências externas.
vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd.syntax("reset")
end

vim.g.colors_name = "catppuccin"
vim.o.background = "dark"

local c = {
  surface1 = "#45475a",
  lavender = "#b4befe",
  surface = "#313244",
  overlay = "#6c7086",
  subtext = "#a6adc8",
  mantle = "#181825",
  yellow = "#f9e2af",
  peach = "#fab387",
  green = "#a6e3a1",
  mauve = "#cba6f7",
  base = "#1e1e2e",
  text = "#cdd6f4",
  teal = "#94e2d5",
  blue = "#89b4fa",
  pink = "#f5c2e7",
  red = "#f38ba8",
  sky = "#89dceb",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Interface
hi("StatusLineNC", { fg = c.subtext, bg = c.surface })
hi("CursorLineNr", { fg = c.yellow, bold = true })
hi("NormalFloat", { fg = c.text, bg = c.mantle })
hi("FloatBorder", { fg = c.blue, bg = c.mantle })
hi("StatusLine", { fg = c.text, bg = c.surface })
hi("VertSplit", { fg = c.surface, bg = c.base })
hi("MatchParen", { fg = c.peach, bold = true })
hi("IncSearch", { fg = c.base, bg = c.peach })
hi("PmenuSel", { fg = c.base, bg = c.blue })
hi("Search", { fg = c.base, bg = c.yellow })
hi("Pmenu", { fg = c.text, bg = c.surface })
hi("NeoTreeDirectoryName", { fg = c.blue })
hi("NeoTreeDirectoryIcon", { fg = c.blue })
hi("Normal", { fg = c.text, bg = c.base })
hi("Title", { fg = c.mauve, bold = true })
hi("NvimTreeFolderName", { fg = c.blue })
hi("NvimTreeFolderIcon", { fg = c.blue })
hi("CursorColumn", { bg = c.surface })
hi("WinSeparator", { fg = c.surface })
hi("ColorColumn", { bg = c.surface })
hi("CursorLine", { bg = c.surface })
hi("Whitespace", { fg = c.surface })
hi("SignColumn", { bg = c.base })
hi("NonText", { fg = c.surface })
hi("Visual", { bg = c.surface1 })
hi("Directory", { fg = c.blue })
hi("LineNr", { fg = c.overlay })

-- Sintaxe
hi("Comment", { fg = c.overlay, italic = true })
hi("Type", { fg = c.yellow, italic = true })
hi("Todo", { fg = c.mauve, bold = true })
hi("StorageClass", { fg = c.yellow })
hi("Conditional", { fg = c.mauve })
hi("Structure", { fg = c.yellow })
hi("Identifier", { fg = c.text })
hi("Statement", { fg = c.mauve })
hi("Character", { fg = c.green })
hi("Constant", { fg = c.peach })
hi("Function", { fg = c.blue })
hi("Keyword", { fg = c.mauve })
hi("Boolean", { fg = c.peach })
hi("PreProc", { fg = c.mauve })
hi("Operator", { fg = c.sky })
hi("Special", { fg = c.pink })
hi("String", { fg = c.green })
hi("Number", { fg = c.peach })
hi("Repeat", { fg = c.mauve })
hi("Error", { fg = c.red })

-- Diagnósticos, LSP e Treesitter
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.teal })
hi("LspReferenceWrite", { bg = c.surface })
hi("LspReferenceText", { bg = c.surface })
hi("LspReferenceRead", { bg = c.surface })
hi("@variable.builtin", { fg = c.red })
hi("DiagnosticWarn", { fg = c.yellow })
hi("@tag.attribute", { fg = c.yellow })
hi("@function", { link = "Function" })
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticInfo", { fg = c.blue })
hi("DiagnosticHint", { fg = c.teal })
hi("@function.call", { fg = c.blue })
hi("@keyword", { link = "Keyword" })
hi("@comment", { link = "Comment" })
hi("@boolean", { link = "Boolean" })
hi("@string", { link = "String" })
hi("@number", { link = "Number" })
hi("@variable", { fg = c.text })
hi("@property", { fg = c.blue })
hi("@type", { link = "Type" })
hi("@tag", { fg = c.mauve })

-- Git e diff
hi("DiffChange", { fg = c.yellow, bg = c.base })
hi("DiffDelete", { fg = c.red, bg = c.base })
hi("DiffAdd", { fg = c.green, bg = c.base })
hi("GitSignsChange", { fg = c.yellow })
hi("GitSignsDelete", { fg = c.red })
hi("GitSignsAdd", { fg = c.green })
