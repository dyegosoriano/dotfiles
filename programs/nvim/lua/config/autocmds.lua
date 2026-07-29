-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Habilitar autoread para recarregar arquivos automaticamente
vim.opt.autoread = true

-- Criar autocmd para verificar mudanças nos arquivos
vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
  { command = "checktime", pattern = "*" }
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fish", "lua", "sh" },
  callback = function()
    vim.bo.fileformat = "unix"
    vim.bo.expandtab = true
    vim.bo.softtabstop = 2
    vim.bo.textwidth = 160
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})
