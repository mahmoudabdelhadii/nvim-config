return {
  'sindrets/diffview.nvim', -- optional - Diff integration
  keys = {

    {
      '<leader>ig',
      mode = { 'n' },
      function()
        require('diffview').open()
      end,
      desc = '[I]ntegrated [G]it',
    },
  },
  config = function()
    require('diffview').setup {
      use_icons = false,
      file_panel = {
        listing_style = 'list', -- One of 'list' or 'tree'
        win_config = { -- See ':h diffview-config-win_config'
          position = 'left',
          width = 35,
          win_opts = {},
        },
      },

      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        view = {
          -- The `view` bindings are active in the diff buffers, only when the current
          -- tabpage is a Diffview.
          { 'n', 'q', ':DiffviewClose<CR>', { desc = '[Q]uit' } },
        },
        file_panel = {
          { 'n', 'q', ':DiffviewClose<CR>', { desc = '[Q]uit' } },
          {
            'n',
            'e',
            function()
              vim.cmd 'wincmd l'
              vim.cmd 'wincmd l'
            end,
            { desc = 'Edit (Jump two windows to the right)' },
          },
          {
            'n',
            'r',
            function()
              local choice = vim.fn.confirm('Discard changes in current file?', '&Yes\n&No', 2)
              if choice == 1 then
                vim.cmd 'wincmd l'
                vim.cmd 'wincmd l'
                vim.cmd ':Git checkout -- %'
              end
            end,
            { desc = 'Prompt Revert Changes' },
          },
          {
            'n',
            'd',
            function()
              local choice = vim.fn.confirm('delete current file?', '&Yes\n&No', 2)
              if choice == 1 then
                vim.cmd 'wincmd l'
                vim.cmd 'wincmd l'
                vim.cmd ':!rm %'
              end
            end,
            { desc = 'Prompt Delete File' },
          },
          {
            'n',
            'c',
            function()
              local choice = vim.fn.confirm('Start safe commit?', '&Yes\n&No', 2)
              if choice == 1 then
                vim.cmd ':Git fetch'
                vim.cmd ':Git pull'
              end
            end,
          },
        },
      },
    }
  end,
}
