-- Agent helpers shared by Claude Code, Codex and Gemini CLI.
-- Everything runs on subscription logins (claude.ai / ChatGPT / Google), never API keys.
local M = {}

M.agents = { 'claude', 'codex', 'gemini' }

-- Headless one-shot commands; the prompt is passed on stdin
M.headless = {
  claude = { 'claude', '-p' },
  codex = { 'codex', 'exec', '--skip-git-repo-check', '-' },
  gemini = { 'gemini', '-p', '' },
}

-- Interactive commands for new worktree sessions
M.interactive = {
  claude = 'claude',
  codex = 'codex',
  gemini = 'gemini',
}

-- API keys exported by the shell take precedence over subscription logins in every
-- agent CLI, so drop them from Neovim's environment (inherited by all child processes).
function M.use_subscriptions()
  for _, var in ipairs { 'ANTHROPIC_API_KEY', 'OPENAI_API_KEY', 'GEMINI_API_KEY', 'GOOGLE_API_KEY' } do
    vim.env[var] = nil
  end
end

function M.default()
  return vim.g.agent_default or 'claude'
end

function M.pick_default()
  vim.ui.select(M.agents, { prompt = 'Default agent for background jobs (now: ' .. M.default() .. ')' }, function(choice)
    if choice then
      vim.g.agent_default = choice
      vim.notify('Default agent: ' .. choice)
    end
  end)
end

local function git(args, cwd)
  local res = vim.system(vim.list_extend({ 'git' }, args), { cwd = cwd, text = true }):wait()
  return res.code == 0 and vim.trim(res.stdout) or nil, res.stderr
end

---Run an agent headless and hand its final answer to `cb` (on the main loop).
---@param agent string
---@param prompt string
---@param cb fun(output:string)
function M.run(agent, prompt, cb)
  local cmd = M.headless[agent]
  if not cmd or vim.fn.executable(cmd[1]) == 0 then
    return vim.notify(agent .. ' CLI not found', vim.log.levels.ERROR)
  end
  if agent == 'gemini' and not vim.uv.fs_stat(vim.fn.expand '~/.gemini/oauth_creds.json') then
    return vim.notify('Gemini is not signed in: run `gemini` once and choose "Sign in with Google"', vim.log.levels.WARN)
  end
  local id = 'agent-' .. agent .. '-' .. vim.uv.hrtime()
  vim.notify(agent .. ' is working…', vim.log.levels.INFO, { id = id, title = 'Agent', timeout = false })
  vim.system(cmd, { stdin = prompt, text = true, cwd = vim.fn.getcwd(), timeout = 10 * 60 * 1000 }, function(res)
    vim.schedule(function()
      Snacks.notifier.hide(id)
      if res.code ~= 0 then
        local why = res.signal == 15 and 'timed out' or (res.stderr or '')
        return vim.notify(agent .. ' failed:\n' .. why, vim.log.levels.ERROR)
      end
      cb(vim.trim(res.stdout))
    end)
  end)
end

local function scratch(title, text, ft)
  Snacks.win {
    title = ' ' .. title .. ' ',
    text = text,
    ft = ft or 'markdown',
    width = 0.6,
    height = 0.6,
    border = 'rounded',
    wo = { wrap = true, conceallevel = 2 },
    keys = { q = 'close' },
  }
end

local function visual_selection()
  local lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() })
  return table.concat(lines, '\n')
end

---Ask the default agent a one-off question about the selection / current file.
function M.ask()
  local in_visual = vim.fn.mode():match '[vV\22]'
  local context = in_visual and visual_selection() or nil
  local file = vim.fn.expand '%:.'
  if in_visual then
    vim.api.nvim_feedkeys(vim.keycode '<Esc>', 'n', false)
  end
  vim.ui.input({ prompt = M.default() .. ' › ' }, function(question)
    if not question or question == '' then
      return
    end
    local prompt = question .. '\n\nFile: ' .. file
    if context then
      prompt = prompt .. '\n\nSelected code:\n```\n' .. context .. '\n```'
    end
    prompt = prompt .. '\n\nAnswer only; do not modify any files.'
    M.run(M.default(), prompt, function(out)
      scratch(M.default() .. ': ' .. question, out)
    end)
  end)
end

---Cross-agent review: another agent reviews uncommitted changes, findings go to quickfix.
function M.review()
  local diff = git { 'diff', 'HEAD' }
  if not diff or diff == '' then
    return vim.notify('No uncommitted changes to review', vim.log.levels.WARN)
  end
  vim.ui.select(M.agents, { prompt = 'Reviewer' }, function(agent)
    if not agent then
      return
    end
    local prompt = table.concat({
      'Review this diff for bugs, regressions and risky changes. Skip style nits.',
      'Output ONLY findings, one per line, exactly in the form:',
      'path/to/file:LINE: severity: message',
      'Use paths relative to the repo root and line numbers from the new file. Output nothing else.',
      '',
      diff,
    }, '\n')
    M.run(agent, prompt, function(out)
      local root = git { 'rev-parse', '--show-toplevel' } or vim.fn.getcwd()
      local items = {}
      for line in out:gmatch '[^\n]+' do
        local file, lnum, msg = line:match '^`?([^:`]+):(%d+):%s*(.+)$'
        if file then
          table.insert(items, { filename = root .. '/' .. file, lnum = tonumber(lnum), text = msg })
        end
      end
      if #items == 0 then
        return scratch(agent .. ' review', out)
      end
      vim.fn.setqflist({}, ' ', { title = agent .. ' review', items = items })
      vim.cmd 'copen'
      vim.notify(('%s found %d issue(s)'):format(agent, #items))
    end)
  end)
end

---Write a commit message for the staged changes into the current gitcommit buffer.
function M.commit_message()
  local buf = vim.api.nvim_get_current_buf()
  local diff = git { 'diff', '--cached' }
  if not diff or diff == '' then
    return vim.notify('Nothing staged', vim.log.levels.WARN)
  end
  local log = git { 'log', '--oneline', '-10' } or ''
  local prompt = table.concat({
    'Write a git commit message for this staged diff. Match the style of the recent commits.',
    'Summary line under 72 chars, blank line, then a short body only if it adds information.',
    'Output ONLY the commit message, no code fences.',
    '',
    'Recent commits:',
    log,
    '',
    diff,
  }, '\n')
  M.run(M.default(), prompt, function(out)
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_set_lines(buf, 0, 0, false, vim.split(out, '\n'))
    end
  end)
end

---Open `cmd` running in `cwd` in a new terminal tab (WezTerm > tmux > Neovim tab).
local function spawn(cwd, cmd)
  local shell = vim.o.shell
  if vim.env.WEZTERM_PANE and vim.fn.executable 'wezterm' == 1 then
    vim.system { 'wezterm', 'cli', 'spawn', '--cwd', cwd, '--', shell, '-ic', cmd }
  elseif vim.env.TMUX then
    vim.system { 'tmux', 'new-window', '-c', cwd, cmd }
  else
    vim.cmd.tabnew()
    vim.cmd.tcd(vim.fn.fnameescape(cwd))
    vim.fn.jobstart(cmd, { term = true, cwd = cwd })
    vim.cmd.startinsert()
  end
end

---Create a git worktree on a new branch and start an agent in it.
function M.worktree_new()
  local root = git { 'rev-parse', '--show-toplevel' }
  if not root then
    return vim.notify('Not in a git repo', vim.log.levels.ERROR)
  end
  vim.ui.input({ prompt = 'New branch: ' }, function(branch)
    if not branch or branch == '' then
      return
    end
    vim.ui.select(M.agents, { prompt = 'Agent' }, function(agent)
      if not agent then
        return
      end
      local path = vim.fs.dirname(root) .. '/' .. vim.fs.basename(root) .. '-' .. branch:gsub('/', '-')
      local _, err = git({ 'worktree', 'add', '-b', branch, path }, root)
      if vim.fn.isdirectory(path) == 0 then
        return vim.notify('git worktree add failed:\n' .. (err or ''), vim.log.levels.ERROR)
      end
      spawn(path, M.interactive[agent])
      vim.notify(('%s started in %s'):format(agent, path))
    end)
  end)
end

---Pick a worktree: open it, start an agent there, review its diff, or remove it.
function M.worktrees()
  local out = git { 'worktree', 'list', '--porcelain' }
  if not out then
    return vim.notify('Not in a git repo', vim.log.levels.ERROR)
  end
  local items = {}
  for block in (out .. '\n\n'):gmatch '(.-)\n\n' do
    local path = block:match '^worktree (%S+)'
    if path then
      table.insert(items, { path = path, branch = (block:match 'branch refs/heads/(%S+)' or 'detached') })
    end
  end
  vim.ui.select(items, {
    prompt = 'Worktrees',
    format_item = function(i)
      return ('%-30s %s'):format(i.branch, i.path)
    end,
  }, function(wt)
    if not wt then
      return
    end
    vim.ui.select({ 'Open in new tab', 'Start agent here', 'Diff vs current branch', 'Remove worktree' }, { prompt = wt.branch }, function(action)
      if action == 'Open in new tab' then
        vim.cmd.tabnew()
        vim.cmd.tcd(vim.fn.fnameescape(wt.path))
        Snacks.picker.files { cwd = wt.path }
      elseif action == 'Start agent here' then
        vim.ui.select(M.agents, { prompt = 'Agent' }, function(agent)
          if agent then
            spawn(wt.path, M.interactive[agent])
          end
        end)
      elseif action == 'Diff vs current branch' then
        vim.cmd('DiffviewOpen HEAD...' .. wt.branch)
      elseif action == 'Remove worktree' then
        if vim.fn.confirm('Remove ' .. wt.path .. '?', '&Yes\n&No', 2) == 1 then
          local _, err = git { 'worktree', 'remove', wt.path }
          vim.notify(err ~= '' and err or ('Removed ' .. wt.path))
        end
      end
    end)
  end)
end

---Open the project's agent instruction file (AGENTS.md / CLAUDE.md / GEMINI.md).
function M.edit_instructions()
  local root = git { 'rev-parse', '--show-toplevel' } or vim.fn.getcwd()
  for _, name in ipairs { 'AGENTS.md', 'CLAUDE.md', 'GEMINI.md' } do
    if vim.uv.fs_stat(root .. '/' .. name) then
      return vim.cmd.edit(vim.fn.fnameescape(root .. '/' .. name))
    end
  end
  vim.cmd.edit(vim.fn.fnameescape(root .. '/AGENTS.md'))
end

---Called by ~/.local/bin/agent-notify (via `nvim --server $NVIM`) from agent hooks.
function M.notify(agent, msg, level)
  vim.notify(msg, level == 'warn' and vim.log.levels.WARN or vim.log.levels.INFO, { title = agent })
end

---Lualine component: running agent sessions + Claude IDE connection.
function M.status()
  local ok, status = pcall(require, 'sidekick.status')
  local parts = {}
  if ok then
    local seen = {}
    for _, s in ipairs(status.cli()) do
      if not seen[s.tool] then
        seen[s.tool] = true
        table.insert(parts, s.tool)
      end
    end
  end
  local cc_ok, cc = pcall(require, 'claudecode')
  if cc_ok and cc.is_claude_connected and cc.is_claude_connected() then
    table.insert(parts, '󰚩 ide')
  end
  return #parts > 0 and ('󱚦 ' .. table.concat(parts, ' ')) or ''
end

return M
