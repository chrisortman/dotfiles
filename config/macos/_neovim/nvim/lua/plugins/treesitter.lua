return {

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'elixir', 'eex', 'heex', 'ruby', 'yaml', 'javascript', 'json' }
      local indent_disabled = { ruby = true }

      require('nvim-treesitter').install(ensure_installed)

      ---@param buf integer
      ---@param language string
      local function try_attach(buf, language)
        if not vim.treesitter.language.add(language) then
          return
        end
        vim.treesitter.start(buf, language)

        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
        if has_indent_query and not indent_disabled[language] then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local installed_parsers = require('nvim-treesitter').get_installed('parsers')
          if vim.tbl_contains(installed_parsers, language) then
            try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            require('nvim-treesitter').install(language):await(function()
              try_attach(buf, language)
            end)
          else
            try_attach(buf, language)
          end
        end,
      })
    end,
  },
}
