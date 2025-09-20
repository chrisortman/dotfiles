return {

  { 'RRethy/nvim-treesitter-endwise', build = ':TSUpdate', opts = function() end, 
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
     config = function(_, opts)
       -- Requires nvim-treesitter installed
      require('nvim-treesitter.configs').setup {
        endwise = {
          enable = true,
        },
      }
     end
  },
}
