return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    _on_attach_pre = function(_, callback)
      if vim.api.nvim_buf_is_valid(vim.api.nvim_get_current_buf()) then
        callback()
      end
    end,
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Next git [C]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Previous git [C]hange' })

      -- Actions
      map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = '[G]it [H]unk [S]tage' })
      map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = '[G]it [H]unk [R]eset' })
      map('v', '<leader>ghs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = '[G]it [H]unk [S]tage' })
      map('v', '<leader>ghr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = '[G]it [H]unk [R]eset' })
      map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = '[G]it [H]unk [S]tage buffer' })
      map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = '[G]it [H]unk [U]ndo stage' })
      map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = '[G]it [H]unk [R]eset buffer' })
      map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = '[G]it [H]unk [P]review' })
      map('n', '<leader>ghb', function() gitsigns.blame_line{full=true} end, { desc = '[G]it [H]unk [B]lame line' })
      map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = '[G]it [T]oggle line [B]lame' })
      map('n', '<leader>ghd', gitsigns.diffthis, { desc = '[G]it [H]unk [D]iff' })
      map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = '[G]it [T]oggle [D]eleted' })

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
    end,
  },
}
