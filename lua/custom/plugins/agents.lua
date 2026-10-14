-- Claude Code / Codex / Gemini in one side panel
return {
  'folke/sidekick.nvim',
  event = 'VeryLazy',
  opts = {
    nes = { enabled = false }, -- next-edit suggestions need Copilot
    cli = {
      win = { layout = 'right', split = { width = 90 } },
      tools = { claude = {}, codex = {}, gemini = {} },
    },
  },
  keys = {
    { '<c-.>', function() require('sidekick.cli').toggle { focus = true } end, mode = { 'n', 't', 'i', 'x' }, desc = 'Agent: toggle' },
    { '<leader>aa', function() require('sidekick.cli').toggle { focus = true } end, desc = 'Agent: toggle' },
    { '<leader>as', function() require('sidekick.cli').select { focus = true } end, desc = 'Agent: select' },
    { '<leader>at', function() require('sidekick.cli').send { msg = '{this}' } end, mode = { 'n', 'x' }, desc = 'Agent: send this' },
    { '<leader>af', function() require('sidekick.cli').send { msg = '{file}' } end, desc = 'Agent: send file' },
    { '<leader>ap', function() require('sidekick.cli').prompt() end, mode = { 'n', 'x' }, desc = 'Agent: prompt' },
  },
}
