return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'modern',
    delay = 300,
    spec = {
      { '<leader>a', group = '[A]gents' },
      { '<leader>g', group = '[G]it' },
      { '<leader>gh', group = '[G]it [H]unk' },
      { '<leader>gt', group = '[G]it [T]oggle' },
      { '<leader>h', group = '[H]arpoon' },
      { '<leader>i', group = '[I]ntegrated tools' },
      { '<leader>j', group = '[J]ust' },
      { '<leader>l', group = '[L]SP' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>S', group = '[S]ession' },
      { '<leader>w', proxy = '<c-w>', group = '[W]indows' },
    },
  },
}
