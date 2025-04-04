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

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" }) -- quit
