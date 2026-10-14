-- AI agents: Claude Code, Codex and Gemini CLI, all on subscription logins.
--   sidekick.nvim   – agent terminals + send context/prompts to any agent
--   claudecode.nvim – Claude's IDE bridge (diffs, selection, diagnostics); its terminal is off
--   codecompanion   – chat buffer for every agent over ACP
local agents = require 'custom.agents'
agents.use_subscriptions()

local function cli(fn, opts)
  return function()
    require('sidekick.cli')[fn](opts)
  end
end

return {
  {
    'folke/sidekick.nvim',
    event = 'VeryLazy',
    opts = {
      nes = { enabled = false }, -- next-edit suggestions need Copilot
      cli = {
        watch = true, -- reload buffers when an agent edits files
        win = { layout = 'right', split = { width = 90 } },
        tools = {
          claude = { cmd = { 'claude', '--ide' } }, -- connect to claudecode.nvim's bridge
          codex = {},
          gemini = {},
        },
        prompts = {
          commit = 'Write a commit message for the staged changes (`git diff --cached`).',
          plan = 'Make a plan for: ',
          refactor = 'Refactor {this} for readability without changing behavior.',
          types = 'Fix the type errors in {file}:\n{diagnostics}',
        },
      },
    },
    keys = {
      { '<c-.>', cli('toggle', { focus = true }), mode = { 'n', 't', 'i', 'x' }, desc = 'Agent: toggle' },
      { '<leader>aa', cli('toggle', { focus = true }), desc = 'Agent: toggle' },
      { '<leader>as', cli('select', { focus = true }), desc = 'Agent: select' },
      { '<leader>ac', cli('toggle', { name = 'claude', focus = true }), desc = 'Agent: Claude' },
      { '<leader>ax', cli('toggle', { name = 'codex', focus = true }), desc = 'Agent: Codex' },
      { '<leader>ag', cli('toggle', { name = 'gemini', focus = true }), desc = 'Agent: Gemini' },
      { '<leader>aq', cli('close'), desc = 'Agent: close session' },
      { '<leader>at', cli('send', { msg = '{this}' }), mode = { 'n', 'x' }, desc = 'Agent: send this' },
      { '<leader>af', cli('send', { msg = '{file}' }), desc = 'Agent: send file' },
      { '<leader>av', cli('send', { msg = '{selection}' }), mode = 'x', desc = 'Agent: send selection' },
      { '<leader>ad', cli('send', { msg = 'Fix these diagnostics in {file}:\n{diagnostics}', submit = true }), desc = 'Agent: fix diagnostics' },
      { '<leader>aQ', cli('send', { msg = 'Fix these:\n{quickfix}', submit = true }), desc = 'Agent: fix quickfix list' },
      { '<leader>ap', cli('prompt'), mode = { 'n', 'x' }, desc = 'Agent: prompt picker' },
      -- Headless jobs on the default agent (<leader>a. to change)
      { '<leader>ak', agents.ask, mode = { 'n', 'x' }, desc = 'Agent: ask (one-shot)' },
      { '<leader>ar', agents.review, desc = 'Agent: cross-agent review → quickfix' },
      { '<leader>a.', agents.pick_default, desc = 'Agent: set default' },
      -- Parallel agents in git worktrees
      { '<leader>aw', agents.worktree_new, desc = 'Agent: new worktree + agent' },
      { '<leader>aW', agents.worktrees, desc = 'Agent: worktrees' },
      { '<leader>aD', '<cmd>DiffviewOpen<cr>', desc = 'Agent: review uncommitted changes' },
      { '<leader>aM', agents.edit_instructions, desc = 'Agent: edit AGENTS.md / CLAUDE.md' },
    },
  },
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    event = 'VeryLazy', -- the bridge must be up before `claude --ide` starts
    opts = {
      log_level = 'warn',
      terminal = { provider = 'none' }, -- sidekick runs the terminal
      diff_opts = { open_in_new_tab = false },
    },
    keys = {
      { '<leader>ay', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Claude: accept diff' },
      { '<leader>an', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Claude: deny diff' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Claude: select model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Claude: add buffer' },
    },
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
    opts = {
      adapters = {
        acp = {
          claude_code = function()
            return require('codecompanion.adapters').extend('claude_code', {
              env = {
                -- `claude setup-token`, stored once in the macOS Keychain (see README)
                CLAUDE_CODE_OAUTH_TOKEN = 'cmd:security find-generic-password -s claude-code-oauth-token -w',
              },
            })
          end,
          codex = function()
            return require('codecompanion.adapters').extend('codex', {
              defaults = { auth_method = 'chat-gpt' },
            })
          end,
          gemini_cli = function()
            return require('codecompanion.adapters').extend('gemini_cli', {
              defaults = { auth_method = 'oauth-personal' },
            })
          end,
        },
      },
      interactions = {
        chat = { adapter = 'claude_code' },
      },
    },
    keys = {
      { '<leader>ao', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'x' }, desc = 'Agent chat (ACP)' },
      { '<leader>aO', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'x' }, desc = 'Agent chat actions' },
    },
  },
}
