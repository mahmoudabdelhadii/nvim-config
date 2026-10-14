return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.ai').setup { n_lines = 500 } -- better a/i textobjects
    require('mini.surround').setup {} -- sa / sd / sr
    require('mini.pairs').setup {}
    require('mini.files').setup {
      mappings = { go_in = 'l', go_in_plus = 'L', go_out = 'h', go_out_plus = 'H' },
      options = { permanent_delete = true, use_as_default_explorer = true },
      windows = { preview = true, width_focus = 30, width_nofocus = 15, width_preview = 100 },
    }

    -- LSP-aware renames/moves (updates imports)
    vim.api.nvim_create_autocmd('User', {
      pattern = { 'MiniFilesActionRename', 'MiniFilesActionMove' },
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })

    vim.keymap.set('n', '<leader>if', function()
      local file = vim.api.nvim_buf_get_name(0)
      MiniFiles.open(vim.uv.fs_stat(file) and file or nil)
    end, { desc = '[I]ntegrated [F]iles (current file)' })
    vim.keymap.set('n', '<leader>iF', function()
      MiniFiles.open()
    end, { desc = '[I]ntegrated [F]iles (cwd)' })
  end,
}
