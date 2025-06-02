return {
  'MagicDuck/grug-far.nvim',
  keys = {
    {
      '<leader>ir',
      mode = { 'n' },
      function()
        require('grug-far').open()
      end,
      desc = '[I]ntegrated [R]eplace',
    },
  },
  config = function()
    require('grug-far').setup {
      windowCreationCommand = 'tabnew %',
    }
  end,
}
