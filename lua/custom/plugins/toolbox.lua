return {
  'DanWlker/toolbox.nvim',
  keys = {
    {
      '<leader>st',
      function()
        require('toolbox').show_picker()
      end,
      desc = '[S]earch [T]oolbox',
      mode = { 'n', 'v' },
    },
  },
  -- If you want to use your custom vim.ui.select overrides, remember to add it into dependencies
  -- to ensure it loads first
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    commands = {
      {
        name = 'Git push origin',
        execute = 'Git push origin HEAD',
      },
      {
        name = 'Git commit -m',
        execute = 'Git commit',
      },
      {
        name = 'Git blame',
        execute = 'Gitsigns blame',
      },
      {
        name = 'Git revert/reset hunk',
        execute = 'Gitsigns reset_hunk',
      },
      {
        name = 'Git revert/reset buffer',
        execute = 'Gitsigns reset_buffer',
      },
      {
        name = 'Git stage hunk',
        execute = 'Gitsigns stage_hunk',
      },
      {
        name = 'AI: set provider',
        execute = 'PrtProvider',
      },
      {
        name = 'AI: set model',
        execute = 'PrtModel',
      },
      {
        name = 'AI: new chat',
        execute = 'PrtChatNew',
      },
      {
        name = 'AI: current status',
        execute = 'PrtStatus',
      },
      {
        name = 'Scratch buffer',
        execute = 'lua Snacks.scratch()',
      },
      {
        name = 'Search Commands',
        execute = 'lua Snacks.picker.commands()',
      },
      {
        name = 'Search text no regex',
        execute = 'lua Snacks.picker.grep({regex = false})',
      },
      {
        name = 'Git main (stashout)',
        execute = '!gitStashout main',
      },
      {
        name = 'PR list',
        execute = 'Octo pr list',
      },
      {
        name = 'PR for current branch',
        execute = 'Octo pr show',
      },
      {
        name = 'Format Json',
        execute = "%!jq '.'",
      },
      {
        name = 'New tab',
        execute = 'tabnew',
      },
      -- {
      --   name = 'Print Vim table',
      --   execute = function(v)
      --     print(vim.inspect(v))
      --   end,
      -- },
      -- -- Note variadic arguments need require_input
      -- {
      --   name = 'Print Variadic arguments',
      --   execute = function(...)
      --     local args = { ... }
      --     print(vim.inspect(args))
      --   end,
      --   require_input = true,
      -- },
      {
        name = 'Copy relative path to clipboard',
        execute = function()
          local path = vim.fn.expand '%'
          vim.fn.setreg('+', path)
        end,
        weight = 2,
      },
      {
        name = 'Copy absolute path to clipboard',
        execute = function()
          local path = vim.fn.expand '%:p'
          vim.fn.setreg('+', path)
        end,
      },
      -- {
      --   name = 'Copy Vim table to clipboard',
      --   execute = function(v)
      --     vim.fn.setreg('+', vim.inspect(v))
      --   end,
      --   tags = { 'first' },
      -- },
      -- {
      --   name = 'Reload plugin',
      --   execute = function(name)
      --     package.loaded[name] = nil
      --     require(name).setup()
      --   end,
      --   tags = { 'first', 'second' },
      -- },
    },
  },
  config = true,
}
