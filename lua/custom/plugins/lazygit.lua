return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('telescope').load_extension('lazygit')
  end,
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    { '<leader>gl', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit Current File' },
    { '<leader>gf', '<cmd>LazyGitFilter<cr>', desc = 'LazyGit Filter' },
    { '<leader>gfc', '<cmd>LazyGitFilterCurrentFile<cr>', desc = 'LazyGit Filter Current File' },
  },
}