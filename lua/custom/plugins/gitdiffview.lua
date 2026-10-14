return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  keys = {
    { '<leader>ig', '<cmd>DiffviewOpen<cr>', desc = '[I]ntegrated [G]it' },
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff view' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
  },
  opts = {
    use_icons = false,
    file_panel = { listing_style = 'list', win_config = { position = 'left', width = 35 } },
    keymaps = {
      view = { { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close' } } },
      file_panel = { { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close' } } },
    },
  },
}
