-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Habilitar autoread para recarregar arquivos automaticamente
vim.opt.autoread = true

-- Criar autocmd para verificar mudanças nos arquivos
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
  pattern = "*",
})

-- Notificar quando um arquivo for alterado externamente
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("Arquivo alterado externamente e recarregado!", vim.log.levels.WARN, { timeout = 5000 })
  end,
})
