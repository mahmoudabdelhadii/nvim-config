return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    auto_restore = false,
    auto_create = false,
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    cwd_change_handling = true,
    log_level = 'error',
  },
  keys = {
    { '<leader>Ss', '<cmd>SessionSearch<cr>', desc = 'Session: search' },
    { '<leader>Sd', '<cmd>SessionDelete<cr>', desc = 'Session: delete' },
    { '<leader>St', '<cmd>SessionToggleAutoSave<cr>', desc = 'Session: toggle auto-save' },
  },
}
