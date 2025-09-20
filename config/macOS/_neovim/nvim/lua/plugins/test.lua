return {

  {
    'vim-test/vim-test', config = function() 
      vim.keymap.set('n', '<leader>t', ':TestNearest<cr>', {remap = false, desc = 'Run closest test'})
      vim.keymap.set('n', '<leader>T', ':TestFile<cr>', {remap = false, desc = 'Run whole test file'})
      vim.keymap.set('n', 'rl', ':TestLast<cr>', {remap = false, desc = 'Run last test'})
      
      
    end,
  },

}
