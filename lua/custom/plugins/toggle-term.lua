return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { [[<c-\>]], desc = 'Toggle terminal' },
  },
  cmd = { 'ToggleTerm', 'TermExec' },
  config = function()
    require('toggleterm').setup {
      direction = 'vertical',
      size = 40,
      open_mapping = [[<c-\>]],
      shade_terminals = true,
      start_in_insert = true,
      close_on_exit = false,
      float_opts = {
        border = 'curved',
        winblend = 0,
      },
    }

    -- Terminal navigation, only in toggleterm windows (Esc must reach TUIs like Claude Code)
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('user-toggleterm-keymaps', { clear = true }),
      pattern = 'toggleterm',
      callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end,
    })
  end,
}
