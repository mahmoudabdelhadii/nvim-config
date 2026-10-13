return {
  'rmagatti/auto-session',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('auto-session').setup({
      enabled = true,
      root_dir = vim.fn.stdpath('data') .. '/sessions/',
      auto_save = true,
      auto_restore = false,
      auto_create = false,
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      allowed_dirs = nil,
      auto_restore_last_session = false,
      use_git_branch = false,
      lazy_support = true,
      bypass_save_filetypes = { 'alpha', 'dashboard' },
      close_unsupported_windows = true,
      args_allow_single_directory = true,
      args_allow_files_auto_save = false,
      continue_restore_on_error = true,
      cwd_change_handling = {
        restore_upcoming_session = true,
        pre_cwd_changed_hook = nil,
        post_cwd_changed_hook = nil,
      },
      log_level = 'error',
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
        mappings = {
          delete_session = { 'i', '<C-D>' },
          alternate_session = { 'i', '<C-S>' },
          copy_session = { 'i', '<C-Y>' },
        },
      },
    })

    -- Session management keymaps (non-conflicting)
    vim.keymap.set('n', '<leader>Ss', require('auto-session.session-lens').search_session, { desc = 'Session: Search' })
    vim.keymap.set('n', '<leader>Sd', '<cmd>SessionDelete<cr>', { desc = 'Session: Delete' })
    vim.keymap.set('n', '<leader>Sp', '<cmd>SessionPurgeOrphaned<cr>', { desc = 'Session: Purge orphaned' })
    vim.keymap.set('n', '<leader>St', '<cmd>SessionToggleAutoSave<cr>', { desc = 'Session: Toggle auto-save' })
  end,
}