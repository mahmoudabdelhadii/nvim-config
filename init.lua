-- Set <space> as the leader keyinit NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- Make line numbers off by default, can set on when needed with :set number
-- Since I use flash by default
vim.opt.number = false

-- Enable mouse mode, can be useful for resizing splits for example!
-- vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.opt.wrap = false

--  Remove this option if you want your OS clipboard to remain independent.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = ' ', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Stop neovim from showing "~" on the start of every row after the last line in the file
vim.opt.fillchars = { eob = ' ' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- By default it shows you the last command you typed. By having this off lualine sits at the very bottom right
vim.opt.cmdheight = 0

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'csv',
  desc = 'Enable CSV View on .csv files',
  callback = function()
    require('csvview').enable()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tweekmonster/django-plus.vim',

  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = true, -- get a notification when changes are found
  },
})

vim.api.nvim_set_keymap('n', '<Leader>w', '<C-w>', { desc = '[W]indow management' })

-- vim.api.nvim_set_keymap('n', '<Leader>w', ':wincmd<Space>', opts?)
vim.api.nvim_create_user_command('CopyRelativePath', function()
  local path = vim.fn.expand '%'
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command('Redir', function(ctx)
  local lines = vim.split(vim.api.nvim_exec(ctx.args, true), '\n', { plain = true })
  vim.cmd 'enew | setlocal buftype=nofile'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })

vim.api.nvim_create_user_command('CurLsp', function()
  vim.cmd 'Redir lua=vim.inspect(vim.lsp.get_active_clients())'
end, {})

vim.api.nvim_create_user_command('NewTerminal', function()
  local term_count = 0
  while true do
    local term_name = 'Term' .. term_count

    local repeat_name = false

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_name(buf) == term_name then
        repeat_name = true
        break
      end
    end
    if not repeat_name then
      vim.cmd(':file ' .. term_name)
      return
    end
  end
end, {})

vim.api.nvim_create_user_command('DeleteCurrentFile', function()
  vim.cmd('!rm ' .. vim.fn.shellescape(vim.fn.expand '%'))
end, { nargs = 0 })

vim.api.nvim_create_user_command('DeleteAndCloseCurrentFile', function()
  vim.cmd('!rm ' .. vim.fn.shellescape(vim.fn.expand '%'))
  vim.cmd 'bdelete!'
end, { nargs = 0 })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local Terminal = require('toggleterm.terminal').Terminal

function RunJustCommand(recipe)
  local direction = recipe == 'test' and 'vertical' or 'float'
  local should_conditional_close = recipe == 'lint' or recipe == 'fmt'

  local just_term = Terminal:new {
    cmd = 'just ' .. recipe,
    direction = direction,
    close_on_exit = false,
    hidden = true,
    on_exit = should_conditional_close and vim.schedule_wrap(function(term, exit_code, _)
      if exit_code == 0 then
        term:close()
      end
    end) or nil,
  }

  just_term:toggle()
end
vim.keymap.set('n', '<leader>jt', function()
  RunJustCommand 'test'
end, { desc = 'Just: Test' })
vim.keymap.set('n', '<leader>jb', function()
  RunJustCommand 'build'
end, { desc = 'Just: Build' })
vim.keymap.set('n', '<leader>jl', function()
  RunJustCommand 'lint'
end, { desc = 'Just: Lint' })
vim.keymap.set('n', '<leader>jf', function()
  RunJustCommand 'fmt'
end, { desc = 'Just: Format' })

-- Disabled keys
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set('n', '<CR>', '<cmd>echo "Dont use enter in normal mode"<CR>')
vim.keymap.set('n', 'q', '<cmd>echo "disabled q to stop recording mishaps"<CR>')

-- Convenience

local function normal_and_visual_keymap(letter, mapping, desc)
  vim.keymap.set('n', letter, mapping, { desc = desc })
  vim.keymap.set('v', letter, mapping, { desc = desc })
end

normal_and_visual_keymap('J', '10j', 'Jump 10 down')
normal_and_visual_keymap('K', '10k', 'Jump 10 up')
normal_and_visual_keymap('H', '^', 'Jump to start of line')
normal_and_visual_keymap('L', '$', 'Jump to end of line')
normal_and_visual_keymap('p', 'P', 'Make paste leave clipboard alone')
normal_and_visual_keymap('c', '"ac', 'Make change leave clipboard alone')
normal_and_visual_keymap('x', '"_x', 'Make delete 1 character leave clipboard alone')
vim.api.nvim_set_keymap('n', 'z', '<C-o>', {})
vim.api.nvim_set_keymap('n', 'Z', '<C-i>', {})

vim.keymap.set('n', '<leader>it', ':term<CR>:file term<CR>a', { desc = '[I]ntegrated [T]erminal' })

vim.keymap.set('n', 'cx', 'r') -- keep all changes under c
vim.keymap.set('c', 'Q', 'q') -- fix typos of Capital Q

vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, { desc = '[L]anguage [H]over' })
