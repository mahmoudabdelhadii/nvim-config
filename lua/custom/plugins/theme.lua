return {
  'Shatur/neovim-ayu',
  lazy = false,
  priority = 1000,
  opts = {
    mirage = false,
    overrides = {
      Pmenu = { fg = '#FFF000' },
      Comment = { fg = '#b0c4de' },
      LineNr = { fg = '#778899' },
      Folded = { fg = '#6495ed' },
      FoldColumn = { fg = '#6495ed' },
    },
  },
  config = function(_, opts)
    require('ayu').setup(opts)
    vim.o.background = 'dark'
    vim.cmd.colorscheme 'ayu-mirage'
  end,
}
