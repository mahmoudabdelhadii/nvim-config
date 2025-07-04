return {
  -- Debug Adapter Protocol
  'mfussenegger/nvim-dap',
  event = 'BufReadPre',
  dependencies = {
    -- UI for nvim-dap (requires nvim-nio)
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
    },
    -- Virtual text for nvim-dap
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    require('nvim-dap-virtual-text').setup {}
    dapui.setup {}

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Key mappings
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'DAP Continue' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'DAP Step Over' })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'DAP Step Into' })
    vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'DAP Step Out' })
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = 'DAP Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>dr', dap.repl.open, { desc = 'DAP Open REPL' })
  end,
}