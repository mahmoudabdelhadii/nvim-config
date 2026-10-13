return {
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    cmd = { 'ClaudeCode', 'ClaudeCodeFocus', 'ClaudeCodeSend', 'ClaudeCodeAdd' },
    opts = {
      terminal = { split_side = 'right', split_width_percentage = 0.4 },
    },
    keys = {
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'AI: Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'AI: Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'AI: Resume Claude session' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'AI: Continue last Claude session' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'AI: Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'AI: Send selection' },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'AI: Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'AI: Deny diff' },
    },
  },
}
