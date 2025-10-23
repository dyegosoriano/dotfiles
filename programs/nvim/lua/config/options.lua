-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = ","  -- (Opcional) Define uma tecla líder local, útil para mapeamentos específicos de buffer
vim.g.mapleader = " "  -- Define a barra de espaço como tecla líder

-- Editor config settings
vim.opt.fileencoding = "utf-8"
vim.opt.fixendofline = true
vim.opt.endofline = true
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.guifont = "Fira Code:h12"
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.number = true

vim.opt.fillchars:append({ eob = " " })
vim.g.netrw_list_hide = ''

vim.o.swapfile = false

-- Habilitar font ligatures
if vim.g.neovide then
  vim.g.neovide_font_ligatures = true
  vim.o.guifont = "Fira Code:h12"
end
