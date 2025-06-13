-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists

  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false

    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end

    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Tmux Navigator
map("n" ,"<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", { desc = "Navegar para a janela anterior" })
map("n" ,"<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", { desc = "Navegar para a janela anterior" })
map("n" ,"<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Navegar para a janela anterior" })
map("n" ,"<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", { desc = "Navegar para a janela anterior" })
map("n" ,"<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", { desc = "Navegar para a janela anterior" })

-- Move Lines
map("v", "<A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

map("v", "<A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })

-- Telescope
map("n", "<leader>fh", "<cmd>Telescope command_history<cr>", { desc = "Buscar por histórico de comandos" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buscar por buffers abertos" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Buscar por arquivos" })
map("n", "<leader>fn", "<cmd>Telescope notify<cr>", { desc = "Buscar por notificações" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Buscar por texto" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Buscar pela lista de TODO" })

-- Neotree
map("n", "<leader>e>", "<cmd>Neotree filesystem reveal right<cr>", { desc = "" })
map("n", "<leader>e<", "<cmd>Neotree filesystem reveal left<cr>", { desc = "" })

-- Lazygit
if vim.fn.executable("lazygit") == 1 then
  -- map("n", "<leader>gg", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
  -- map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Git Log" })
  map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
  map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
  map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
end

-- Others
-- map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" }) -- Save file
map("n", "<leader>wqa", "<cmd>wqa<cr>", { desc = "Save and Quit All" })
map("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all files" })
map("n", "<leader>nf", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

-- windows
map("n", "<leader>tl", "<cmd>rightbelow vsplit | vertical resize 80 | terminal<cr>", { desc = "Split Window Right and Open Terminal", remap = true })
map("n", "<leader>tb", "<cmd>belowright split | resize 10 | terminal<cr>", { desc = "Split Window Below and Open Terminal", remap = true })

map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- LSP
map("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>lr", vim.lsp.buf.references, { desc = "List references" })
map("n", "<leader>ldoc", vim.lsp.buf.hover, { desc = "Show Documentation" }) -- Mostra documentação ao passar o cursor
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format code" })
-- map("n", "<space>rn", vim.lsp.buf.rename, { desc = "" }) -- Renomeia símbolos

-- MCPHub
map("n", "<leader>am", "<cmd>MCPHub<CR>")

