return {
  { -- :Rg / rip grep
    'duane9/nvim-rg',
    config = function()
      vim.keymap.set('n', '<leader>a', "<CMD>Rg <cword><CR>", { desc = "Search for word under cursor" })
    end
  },
}
