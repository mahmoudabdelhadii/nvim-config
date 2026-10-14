vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.loader.enable()
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- AI agents run on subscription logins; shell API keys would take precedence
for _, var in ipairs { 'ANTHROPIC_API_KEY', 'OPENAI_API_KEY', 'GEMINI_API_KEY', 'GOOGLE_API_KEY' } do
  vim.env[var] = nil
end

-- Options
local o = vim.opt
o.number = false
o.showmode = false
o.wrap = false
o.clipboard = 'unnamedplus'
o.breakindent = true
o.undofile = true
o.undolevels = 10000
o.inccommand = 'nosplit'
o.grepformat = '%f:%l:%c:%m'
o.grepprg = 'rg --vimgrep'
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.updatetime = 200
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.splitkeep = 'screen'
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.fillchars = { eob = ' ' }
o.cursorline = true
o.scrolloff = 10
o.cmdheight = 0
o.completeopt = 'menu,menuone,noselect'
o.pumheight = 10
o.pumblend = 10
o.winblend = 10
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true
o.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds', 'localoptions' }
o.foldtext = '' -- native highlighted fold text
o.autoread = true

-- Autocommands
local group = vim.api.nvim_create_augroup('user', { clear = true })

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'TermLeave' }, {
  desc = 'Reload files changed outside Neovim (agents, git)',
  group = group,
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth',
  { import = 'custom.plugins' },
}, {
  change_detection = { enabled = false },
  rocks = { enabled = false },
})

-- Commands
vim.api.nvim_create_user_command('CopyRelativePath', function()
  local path = vim.fn.expand '%'
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '"')
end, {})

vim.api.nvim_create_user_command('DeleteCurrentFile', function()
  local file = vim.fn.expand '%:p'
  if vim.fn.confirm('Delete ' .. vim.fn.expand '%:.' .. '?', '&Yes\n&No', 2) == 1 then
    Snacks.bufdelete { force = true }
    vim.fs.rm(file)
  end
end, {})

vim.cmd 'command! -nargs=0 -bar WA wall'
vim.cmd 'cnoreabbrev Q q'

-- Keymaps
local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Macros on Q so a stray q never starts recording
map('n', 'q', '<Nop>')
map('n', 'Q', 'q', { desc = 'Record macro' })

-- hjkl only
for _, key in ipairs { '<Left>', '<Right>', '<Up>', '<Down>' } do
  map('n', key, '<Nop>')
end

map({ 'n', 'x' }, 'H', '^', { desc = 'Start of line' })
map({ 'n', 'x' }, 'L', '$', { desc = 'End of line' })
map('x', 'p', 'P', { desc = 'Paste without yanking selection' })
map({ 'n', 'x' }, 'c', '"ac', { desc = 'Change without touching clipboard' })
map({ 'n', 'x' }, 'x', '"_x', { desc = 'Delete char without touching clipboard' })
map('n', 'cx', 'r', { desc = 'Replace char' })

-- Terminals (Snacks)
map({ 'n', 't' }, [[<C-\>]], function()
  Snacks.terminal.toggle()
end, { desc = 'Toggle terminal' })

-- just recipes
for key, recipe in pairs { t = 'test', b = 'build', l = 'lint', f = 'fmt' } do
  map('n', '<leader>j' .. key, function()
    Snacks.terminal('just ' .. recipe, {
      auto_close = false,
      win = { position = recipe == 'test' and 'right' or 'float' },
    })
  end, { desc = 'just ' .. recipe })
end
