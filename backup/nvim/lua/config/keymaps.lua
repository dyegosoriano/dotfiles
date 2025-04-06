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

-- Telescope
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buscar por buffers abertos" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Buscar por arquivos" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Buscar por texto" })

-- Neotree
map("n", "<leader>e>", "<cmd>Neotree filesystem reveal right<cr>", { desc = "" })
map("n", "<leader>e<", "<cmd>Neotree filesystem reveal left<cr>", { desc = "" })

-- Lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Git Log" })
  map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
  map("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
  map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
end

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" }) -- save file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" }) -- new file
-- map("n", "<leader>qw", "<cmd>wqa<cr>", { desc = "Save and Quit All" }) -- save and quit
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" }) -- quit
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" }) -- lazy

-- Move Lines
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })

-- windows
-- map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
-- map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
-- map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
-- Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
-- Snacks.toggle.zen():map("<leader>uz")

-- commenting
-- map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
-- map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- better indenting
-- map("v", "<", "<gv")
-- map("v", ">", ">gv")
