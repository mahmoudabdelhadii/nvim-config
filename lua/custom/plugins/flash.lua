return {
  'folke/flash.nvim',
  ---@type Flash.Config
  opts = {
    modes = { char = { enabled = false } },
    label = { rainbow = { enabled = false } },
  },
  keys = {
    { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
  },
}
