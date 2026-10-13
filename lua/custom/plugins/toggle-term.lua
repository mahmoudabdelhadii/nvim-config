return {
  'akinsho/toggleterm.nvim',
  version = '*',
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

    -- Create AI terminals
    local Terminal = require('toggleterm.terminal').Terminal

    -- Claude Code terminal
    local claude_terminal = Terminal:new {
      cmd = 'claude',
      dir = 'git_dir',
      direction = 'vertical',
      close_on_exit = false,
      hidden = true,
      count = 99,
      display_name = 'Claude',
    }

    -- Gemini terminal (if you have gemini-cli installed)
    local gemini_terminal = Terminal:new {
      cmd = 'gemini',
      dir = 'git_dir',
      direction = 'vertical',
      close_on_exit = false,
      hidden = true,
      count = 98,
      display_name = 'Gemini',
    }

    -- AI terminal keymaps
    vim.keymap.set('n', '<leader>ac', function()
      claude_terminal:toggle()
    end, { desc = 'AI: Claude Terminal' })
    vim.keymap.set('n', '<leader>ag', function()
      gemini_terminal:toggle()
    end, { desc = 'AI: Gemini Terminal' })

    -- Quick AI file explanation
    vim.keymap.set('n', '<leader>ae', function()
      local current_file = vim.fn.expand '%:p'
      if current_file == '' then
        vim.notify('No file open', vim.log.levels.WARN)
        return
      end

      local explain_terminal = Terminal:new {
        cmd = 'claude explain ' .. vim.fn.shellescape(current_file),
        direction = 'vertical',
        close_on_exit = false,
        hidden = true,
        display_name = 'Claude Explain',
      }
      explain_terminal:toggle()
    end, { desc = 'AI: Explain current file' })
    
    -- Copy current file path for AI
    vim.keymap.set('n', '<leader>af', function()
      local current_file = vim.fn.expand '%:p'
      if current_file == '' then
        vim.notify('No file open', vim.log.levels.WARN)
        return
      end
      
      vim.fn.setreg('+', current_file)
      claude_terminal:toggle()
      vim.notify('File path copied to clipboard: ' .. vim.fn.fnamemodify(current_file, ':t'), vim.log.levels.INFO)
    end, { desc = 'AI: Open Claude with current file path' })
    
    -- Copy selected text for AI
    vim.keymap.set('v', '<leader>as', function()
      -- Get selected text
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      local lines = vim.fn.getline(start_pos[2], end_pos[2])
      
      -- Handle partial line selection
      if start_pos[2] == end_pos[2] then
        -- Single line selection
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
      else
        -- Multi-line selection
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
      end
      
      local selected_text = table.concat(lines, '\n')
      vim.fn.setreg('+', selected_text)
      claude_terminal:toggle()
      vim.notify('Selected code copied to clipboard for AI', vim.log.levels.INFO)
    end, { desc = 'AI: Copy selection and open Claude' })
    
    -- Quick code review
    vim.keymap.set('n', '<leader>ar', function()
      local current_file = vim.fn.expand '%:p'
      if current_file == '' then
        vim.notify('No file open', vim.log.levels.WARN)
        return
      end

      local review_terminal = Terminal:new {
        cmd = 'claude review ' .. vim.fn.shellescape(current_file),
        direction = 'vertical',
        close_on_exit = false,
        hidden = true,
        display_name = 'Claude Review',
      }
      review_terminal:toggle()
    end, { desc = 'AI: Review current file' })
    
    -- Ask Claude to optimize code
    vim.keymap.set('n', '<leader>ao', function()
      local current_file = vim.fn.expand '%:p'
      if current_file == '' then
        vim.notify('No file open', vim.log.levels.WARN)
        return
      end

      local optimize_terminal = Terminal:new {
        cmd = 'claude optimize ' .. vim.fn.shellescape(current_file),
        direction = 'vertical',
        close_on_exit = false,
        hidden = true,
        display_name = 'Claude Optimize',
      }
      optimize_terminal:toggle()
    end, { desc = 'AI: Optimize current file' })

    -- Terminal navigation keymaps
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
  end,
}
