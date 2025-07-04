-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Performance optimizations
vim.loader.enable()
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Options
vim.opt.number = false
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.inccommand = 'nosplit'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = ' ', nbsp = '␣' }
vim.opt.fillchars = { eob = ' ' }
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.cmdheight = 0
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.splitkeep = 'screen'
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
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

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth',
  'tweekmonster/django-plus.vim',
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙', keys = '🗝',
      plugin = '🔌', runtime = '💻', require = '🌙', source = '📄', start = '🚀',
      task = '📌', lazy = '💤 ',
    },
  },
  change_detection = { enabled = false, notify = true },
})

-- Commands
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

-- Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Just commands
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
      if exit_code == 0 then term:close() end
    end) or nil,
  }
  just_term:toggle()
end

vim.keymap.set('n', '<leader>jt', function() RunJustCommand 'test' end, { desc = 'Just: Test' })
vim.keymap.set('n', '<leader>jb', function() RunJustCommand 'build' end, { desc = 'Just: Build' })
vim.keymap.set('n', '<leader>jl', function() RunJustCommand 'lint' end, { desc = 'Just: Lint' })
vim.keymap.set('n', '<leader>jf', function() RunJustCommand 'fmt' end, { desc = 'Just: Format' })

-- Disabled keys
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set('n', 'q', '<cmd>echo "disabled q to stop recording mishaps"<CR>')

-- Enhanced movement
local function nv_keymap(key, mapping, desc)
  vim.keymap.set('n', key, mapping, { desc = desc })
  vim.keymap.set('v', key, mapping, { desc = desc })
end

nv_keymap('J', '10j', 'Jump 10 down')
nv_keymap('K', '10k', 'Jump 10 up')
nv_keymap('H', '^', 'Jump to start of line')
nv_keymap('L', '$', 'Jump to end of line')
nv_keymap('p', 'P', 'Make paste leave clipboard alone')
nv_keymap('c', '"ac', 'Make change leave clipboard alone')
nv_keymap('x', '"_x', 'Make delete 1 character leave clipboard alone')

vim.keymap.set('n', 'z', '<C-o>')
vim.keymap.set('n', 'Z', '<C-i>')
vim.keymap.set('n', '<leader>it', ':term<CR>:file term<CR>a', { desc = '[I]ntegrated [T]erminal' })
vim.keymap.set('n', 'cx', 'r')
vim.keymap.set('c', 'Q', 'q')

