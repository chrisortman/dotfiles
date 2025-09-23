return {
  {
    'stevearc/oil.nvim',
    event = 'VimEnter',
    opts = {
      keymaps = {
        ["gq"] = "actions.close"
      }
    },
    init = function()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<leader>n", "<CMD>lua require('oil.actions').open_cwd.callback()<CR>", { desc = "Open directory browser" })
      vim.keymap.set("n", "<leader>.", "<CMD>lua require('oil.actions').open_terminal.callback()<CR>", { desc = "Open directory browser" })
    end
  },

}
