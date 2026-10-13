-- nvim-treesitter `main` branch: installs parsers only; highlighting, folding and
-- indent use Neovim's native treesitter. Incremental selection is native too
-- (visual mode `an` / `in` / `]n` / `[n`).
local parsers = {
  'bash', 'c', 'css', 'dockerfile', 'elixir', 'go', 'html', 'javascript', 'json',
  'just', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'rust',
  'terraform', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end
          -- Install missing parsers on demand (replaces auto_install)
          if not vim.treesitter.language.add(lang) then
            if vim.tbl_contains(require('nvim-treesitter').get_available(), lang) then
              require('nvim-treesitter').install(lang)
            end
            return
          end
          vim.treesitter.start(args.buf, lang)
          vim.wo[0][0].foldmethod = 'expr'
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldlevel = 99
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local select = require('nvim-treesitter-textobjects.select').select_textobject
      for keys, query in pairs {
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
        aa = '@parameter.outer',
        ia = '@parameter.inner',
      } do
        vim.keymap.set({ 'x', 'o' }, keys, function() select(query, 'textobjects') end, { desc = 'TS ' .. query })
      end

      local move = require 'nvim-treesitter-textobjects.move'
      for keys, spec in pairs {
        [']m'] = { move.goto_next_start, '@function.outer' },
        [']]'] = { move.goto_next_start, '@class.outer' },
        [']M'] = { move.goto_next_end, '@function.outer' },
        [']['] = { move.goto_next_end, '@class.outer' },
        ['[m'] = { move.goto_previous_start, '@function.outer' },
        ['[['] = { move.goto_previous_start, '@class.outer' },
        ['[M'] = { move.goto_previous_end, '@function.outer' },
        ['[]'] = { move.goto_previous_end, '@class.outer' },
      } do
        vim.keymap.set({ 'n', 'x', 'o' }, keys, function() spec[1](spec[2], 'textobjects') end, { desc = 'TS ' .. spec[2] })
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = { max_lines = 3, multiline_threshold = 1 },
  },
}
