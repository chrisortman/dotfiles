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


-- Navigate split windows, falling back to herdr panes at edges
local function smart_navigate(direction)
  local move_map = { h = 'left', j = 'down', k = 'up', l = 'right' }
  local winnr_before = vim.fn.winnr()
  vim.cmd('wincmd ' .. direction)
  if vim.fn.winnr() == winnr_before then
    if vim.env.HERDR_ENV == '1' then
      vim.fn.system('herdr pane focus --direction ' .. move_map[direction])
    end
  end
end
vim.keymap.set('n', '<C-h>', function() smart_navigate('h') end, { desc = 'Focus left split or herdr pane' })
vim.keymap.set('n', '<C-j>', function() smart_navigate('j') end, { desc = 'Focus down split or herdr pane' })
vim.keymap.set('n', '<C-k>', function() smart_navigate('k') end, { desc = 'Focus up split or herdr pane' })
vim.keymap.set('n', '<C-l>', function() smart_navigate('l') end, { desc = 'Focus right split or herdr pane' })
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
--vim.cmd[[set termguicolors]]
vim.o.termguicolors = true
vim.opt.background = 'dark'
--vim.cmd.colorscheme 'monokai-pro'
vim.cmd.colorscheme('monokai')

vim.cmd.hi 'Comment gui=none'

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
