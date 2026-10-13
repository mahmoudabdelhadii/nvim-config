return {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'junegunn/fzf',
  },
  config = function()
    require('bqf').setup({
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = 'rounded',
        should_preview_cb = function(bufnr)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            ret = false
          end
          return ret
        end,
      },
      func_map = {
        drop = 'o',
        openc = 'O',
        split = '<C-s>',
        vsplit = '<C-v>',
        tab = 't',
        tabb = 'T',
        tabc = '<C-t>',
        tabdrop = '',
        ptogglemode = 'z,',
        pscrollup = '<C-b>',
        pscrolldown = '<C-f>',
        pscrollorig = 'zo',
        prevfile = '<C-p>',
        nextfile = '<C-n>',
        prevhist = '<',
        nexthist = '>',
        lastleave = [['"]],
        stoggleup = '<S-Tab>',
        stoggledown = '<Tab>',
        stogglevm = '<Tab>',
        stogglebuf = [['<Tab>]],
        sclear = 'z<Tab>',
        filter = 'zn',
        filterr = 'zN',
        fzffilter = 'zf',
      },
      filter = {
        fzf = {
          action_for = { ['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit' },
          extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' },
        },
      },
    })
  end,
}