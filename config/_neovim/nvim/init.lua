-- Tell neovim to use this file with NVIM_APPNAME=neovim-neu nvim
-- Reload this file with :luafile ~/.config/neovim-neu/init.lua
vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.opt.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 3
vim.o.signcolumn = 'yes'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.guifont = 'Berkeley Mono:h14'


-- Navigate  split windows without having to use control key
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', {remap = true, desc = 'Select split above'})
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', {remap = true, desc = 'Select split below'})
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', {remap = true, desc = 'Select split left'})
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', {remap = true, desc = 'Select split right'})
-- Terminal mode mappings for window navigation
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])

-- Clear search when you hit escape
-- nnoremap <silent> <Esc> <Esc>:noh<CR>
vim.keymap.set('n', '<Esc>', '<Esc>:noh<cr>', { remap = true, silent = true, desc = 'Clear search highlight' })

vim.cmd('abbr fro # frozen_string_literal: true')
vim.cmd('abbr aeq assert_equal')

require("config.lazy")

-- This has to be set so that some color schemes (molokai) will define 
-- the correct color mappings when they load.
vim.cmd[[set termguicolors]]

vim.o.background = 'dark'
vim.cmd.colorscheme 'tokyonight'
vim.cmd.hi 'Comment gui=none'
