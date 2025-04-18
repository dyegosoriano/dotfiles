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

vim.opt.guifont = "Fira Code"
vim.opt.relativenumber = false
vim.opt.number = true

vim.g.netrw_list_hide = ''
