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
  pink = "#f694ff",
  blue = "#82e2ff",
  red = "#ff6767",
  bg = "#15141b",
  fg = "#edecee",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Interface
hi("VertSplit", { fg = c.surface, bg = c.bg }) -- Define o separador vertical entre janelas.
hi("Pmenu", { fg = c.fg, bg = c.surface }) -- Define o menu de conclusão não selecionado.
hi("ColorColumn", { bg = c.surface }) -- Destaca a coluna configurada por colorcolumn.
hi("Whitespace", { fg = c.surface }) -- Exibe caracteres de espaço em uma cor discreta.
hi("NonText", { fg = c.surface }) -- Colore caracteres fora do conteúdo do buffer.

hi("StatusLineNC", { fg = c.muted, bg = c.bg }) -- Define a barra de status de janelas inativas.
hi("StatusLine", { fg = c.fg, bg = c.bg }) -- Define a barra de status da janela ativa.
hi("WinSeparator", { fg = c.surface }) -- Define o separador entre janelas divididas.
hi("CursorColumn", { bg = c.bg }) -- Define o fundo da coluna onde está o cursor.
hi("CursorLine", { bg = c.bg }) -- Define o fundo da linha onde está o cursor.

hi("CursorLineNr", { fg = c.purple, bold = true }) -- Destaca o número da linha atual em laranja.
hi("MatchParen", { fg = c.orange, bold = true }) -- Destaca parênteses correspondentes em laranja.
hi("FloatBorder", { fg = c.purple, bg = c.bg }) -- Define a borda roxa das janelas flutuantes.
hi("IncSearch", { fg = c.bg, bg = c.purple }) -- Destaca a ocorrência atual da busca com fundo roxo.
hi("PmenuSel", { fg = c.bg, bg = c.purple }) -- Destaca o item selecionado do menu de conclusão.
hi("NormalFloat", { fg = c.fg, bg = c.bg }) -- Define as cores de texto e fundo das janelas flutuantes.
hi("Title", { fg = c.purple, bold = true }) -- Define títulos em roxo e negrito.
hi("Search", { fg = c.bg, bg = c.orange }) -- Destaca os resultados de busca com fundo laranja.
hi("Normal", { fg = c.fg, bg = c.bg }) -- Define as cores padrão de texto e fundo do editor.
hi("Visual", { bg = c.selection }) -- Define o fundo do texto selecionado.
hi("Directory", { fg = c.purple }) -- Colore nomes de diretórios gerais em roxo.
hi("SignColumn", { bg = c.bg }) -- Define o fundo da coluna de sinais.
hi("LineNr", { fg = c.muted }) -- Colore números de linha não ativos em cinza discreto.

hi("NeoTreeDirectoryName", { fg = c.purple }) -- Colore nomes de diretórios no Neo-tree em roxo.
hi("NeoTreeDirectoryIcon", { fg = c.purple }) -- Colore ícones de diretórios no Neo-tree em roxo.
hi("NvimTreeFolderName", { fg = c.purple }) -- Colore nomes de pastas no NvimTree em roxo.
hi("NvimTreeFolderIcon", { fg = c.purple }) -- Colore ícones de pastas no NvimTree em roxo.
hi("NvimTreeFileName", { fg = c.purple }) -- Colore nomes de arquivos no NvimTree em roxo.
hi("NeoTreeFileName", { fg = c.purple }) -- Colore nomes de arquivos no Neo-tree em roxo.
hi("NvimTreeFileIcon", { fg = c.pink }) -- Colore ícones de arquivos no NvimTree em rosa.
hi("NeoTreeFileIcon", { fg = c.pink }) -- Colore ícones de arquivos no Neo-tree em rosa.

-- Sintaxe
hi("Comment", { fg = c.muted, italic = true }) -- Colore comentários em cinza e itálico.
hi("@punctuation.special", { fg = c.purple }) -- Colore pontuações especiais, como ..., em roxo.
hi("Type", { fg = c.blue, italic = true }) -- Colore tipos em azul e itálico.
hi("Todo", { fg = c.blue, bold = true }) -- Destaca marcadores TODO em azul e negrito.
hi("StorageClass", { fg = c.orange }) -- Colore classes de armazenamento em laranja.
hi("Conditional", { fg = c.purple }) -- Colore condicionais em roxo.
hi("Statement", { fg = c.purple }) -- Colore declarações de controle em roxo.
hi("Structure", { fg = c.orange }) -- Colore estruturas de dados em laranja.
hi("@operator", { fg = c.purple }) -- Colore operadores do Treesitter, como => e ===, em roxo.
hi("Character", { fg = c.green }) -- Colore caracteres literais em verde.
hi("Constant", { fg = c.purple }) -- Colore constantes em roxo.
hi("Function", { fg = c.orange }) -- Colore funções do grupo Vim tradicional em laranja.
hi("Operator", { fg = c.purple }) -- Colore operadores do grupo Vim tradicional em roxo.
hi("Keyword", { fg = c.purple }) -- Colore palavras-chave em roxo.
hi("PreProc", { fg = c.purple }) -- Colore diretivas de pré-processamento em roxo.
hi("Identifier", { fg = c.fg }) -- Mantém identificadores na cor de texto padrão.
hi("Boolean", { fg = c.green }) -- Colore valores booleanos em verde.
hi("Repeat", { fg = c.purple }) -- Colore estruturas de repetição em roxo.
hi("String", { fg = c.green }) -- Colore textos literais em verde.
hi("Number", { fg = c.green }) -- Colore valores numéricos em verde.
hi("Special", { fg = c.pink }) -- Colore símbolos especiais em rosa.
hi("Error", { fg = c.red }) -- Colore erros de sintaxe em vermelho.

-- Diagnósticos, LSP e Treesitter
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.orange }) -- Sublinha avisos com ondulação laranja.
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.purple }) -- Sublinha dicas com ondulação roxa.
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red }) -- Sublinha erros com ondulação vermelha.
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue }) -- Sublinha informações com ondulação azul.
hi("@lsp.type.decorator", { fg = c.orange }) -- Colore decoradores semânticos do LSP em laranja.
hi("@attribute.builtin", { fg = c.orange }) -- Colore atributos internos em laranja.
hi("@lsp.type.function", { fg = c.orange }) -- Colore funções semânticas fornecidas pelo LSP em laranja.
hi("LspReferenceWrite", { bg = c.surface }) -- Destaca referências que serão escritas.
hi("@variable.builtin", { fg = c.purple }) -- Colore variáveis internas em roxo.
hi("LspReferenceText", { bg = c.surface }) -- Destaca referências de texto do LSP.
hi("LspReferenceRead", { bg = c.surface }) -- Destaca referências que serão lidas.
hi("@lsp.type.property", { fg = c.pink }) -- Colore propriedades semânticas do LSP em rosa.
hi("@lsp.type.method", { fg = c.orange }) -- Colore métodos semânticos do LSP em laranja.
hi("@function.builtin", { fg = c.pink }) -- Colore funções internas do Treesitter em rosa.
hi("DiagnosticWarn", { fg = c.orange }) -- Colore mensagens de aviso em laranja.
hi("DiagnosticHint", { fg = c.purple }) -- Colore mensagens de dica em roxo.
hi("@lsp.type.class", { fg = c.blue }) -- Colore classes semânticas do LSP em azul.
hi("@function", { link = "Function" }) -- Faz funções do Treesitter usarem a cor do grupo Function.
hi("DiagnosticError", { fg = c.red }) -- Colore mensagens de erro em vermelho.
hi("@lsp.type.type", { fg = c.blue }) -- Colore tipos semânticos do LSP em azul.
hi("@tag.attribute", { fg = c.blue }) -- Colore atributos de tags, como HTML, em azul.
hi("DiagnosticInfo", { fg = c.blue }) -- Colore mensagens informativas em azul.
hi("@function.call", { fg = c.pink }) -- Colore chamadas de função em rosa.
hi("@constructor", { fg = c.purple }) -- Colore construtores em roxo.
hi("@type.builtin", { fg = c.blue }) -- Colore tipos internos em azul.
hi("@boolean", { link = "Boolean" }) -- Faz booleanos do Treesitter usarem a cor verde de Boolean.
hi("@keyword", { link = "Keyword" }) -- Faz palavras-chave do Treesitter usarem a cor de Keyword.
hi("@comment", { link = "Comment" }) -- Faz comentários do Treesitter usarem a cor de Comment.
hi("@method.call", { fg = c.pink }) -- Colore chamadas de métodos em rosa.
hi("@attribute", { fg = c.orange }) -- Colore decoradores e atributos do Treesitter em laranja.
hi("@string", { link = "String" }) -- Faz textos do Treesitter usarem a cor verde de String.
hi("@number", { link = "Number" }) -- Faz números do Treesitter usarem a cor verde de Number.
hi("@property", { fg = c.pink }) -- Colore propriedades de objetos em rosa.
hi("@variable", { fg = c.fg }) -- Mantém variáveis na cor de texto padrão.
hi("@method", { fg = c.pink }) -- Colore definições de métodos em rosa.
hi("@type", { link = "Type" }) -- Faz tipos do Treesitter usarem a cor azul de Type.
hi("@field", { fg = c.pink }) -- Colore campos de objetos em rosa.
hi("@class", { fg = c.blue }) -- Colore nomes de classes em azul.
hi("@tag", { fg = c.purple }) -- Colore tags de marcação em roxo.

-- Git e diff
hi("DiffChange", { fg = c.orange, bg = c.bg }) -- Colore linhas modificadas em laranja.
hi("DiffDelete", { fg = c.red, bg = c.bg }) -- Colore linhas removidas em vermelho.
hi("DiffAdd", { fg = c.green, bg = c.bg }) -- Colore linhas adicionadas em verde.
hi("GitSignsChange", { fg = c.orange }) -- Colore o sinal Git de modificação em laranja.
hi("GitSignsDelete", { fg = c.red }) -- Colore o sinal Git de remoção em vermelho.
hi("GitSignsAdd", { fg = c.green }) -- Colore o sinal Git de adição em verde.
