return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup({
      preset = 'modern',
      delay = 300,
    })

    -- Document existing key chains
    require('which-key').add({
      { '<leader>l', group = '[L]anguage/LSP' },
      { '<leader>j', group = '[J]ust commands' },
      { '<leader>i', group = '[I]ntegrated tools' },
      { '<leader>x', group = 'Trouble/Diagnostics' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>w', group = '[W]indow' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>g', group = '[G]it' },
      { '<leader>gh', group = '[G]it [H]unk' },
      { '<leader>gt', group = '[G]it [T]oggle' },
      { ']', group = 'Next' },
      { '[', group = 'Previous' },
      { 'g', group = '[G]oto' },
    })
  end,
}
