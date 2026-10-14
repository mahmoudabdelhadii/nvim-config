local function pick(source, opts)
  return function()
    Snacks.picker[source](opts)
  end
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {},
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      },
      sections = {
        { section = 'header' },
        -- Plain text instead of a terminal section, so there's no "[Process exited 0]"
        function()
          if vim.fn.executable 'fortune' == 0 or vim.fn.executable 'cowsay' == 0 then
            return {}
          end
          local cow = vim.trim(vim.fn.system 'fortune -s | cowsay -r')
          local width = 0
          for _, line in ipairs(vim.split(cow, '\n')) do
            width = math.max(width, vim.api.nvim_strwidth(line))
          end
          return { text = { cow, hl = 'SnacksDashboardDesc', align = 'left', width = width }, padding = 1 }
        end,
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    words = { enabled = true },
    picker = {
      enabled = true,
      matcher = { ignorecase = true },
      layout = { preset = 'telescope' },
      win = {
        preview = { wo = { number = false } },
        input = { minimal = true },
      },
    },
  },
  keys = {
    -- Find
    { '<leader><leader>', pick 'smart', desc = 'Smart find files' },
    { '<leader>sf', pick 'files', desc = '[S]earch [F]iles' },
    { '<leader>se', pick('files', { hidden = true, ignored = true, title = 'Everything' }), desc = '[S]earch [E]verything' },
    { '<leader>so', pick 'buffers', desc = '[S]earch [O]pen buffers' },
    { '<leader>sp', pick 'grep', desc = '[S]earch [P]roject (grep)' },
    { '<leader>sw', pick 'grep_word', mode = { 'n', 'x' }, desc = '[S]earch [W]ord / selection' },
    { '<leader>sb', pick 'lines', desc = '[S]earch [B]uffer lines' },
    { '<leader>sB', pick 'grep_buffers', desc = '[S]earch open [B]uffers' },
    { '<leader>sd', pick 'diagnostics', desc = '[S]earch [D]iagnostics' },
    { '<leader>sD', pick 'diagnostics_buffer', desc = '[S]earch buffer [D]iagnostics' },
    { '<leader>sh', pick 'help', desc = '[S]earch [H]elp' },
    { '<leader>sk', pick 'keymaps', desc = '[S]earch [K]eymaps' },
    { '<leader>sc', pick 'commands', desc = '[S]earch [C]ommands' },
    { '<leader>sq', pick 'qflist', desc = '[S]earch [Q]uickfix' },
    { '<leader>s"', pick 'registers', desc = '[S]earch registers' },
    { '<leader>sr', pick 'resume', desc = '[S]earch [R]esume' },
    { '<leader>ss', pick 'pickers', desc = '[S]earch pickers' },
    -- LSP
    { 'gd', pick 'lsp_definitions', desc = 'Goto definition' },
    { 'gD', pick 'lsp_declarations', desc = 'Goto declaration' },
    { 'gr', pick 'lsp_references', nowait = true, desc = 'References' },
    { 'gI', pick 'lsp_implementations', desc = 'Goto implementation' },
    { 'gy', pick 'lsp_type_definitions', desc = 'Goto type definition' },
    -- Git
    { '<leader>gs', pick 'git_status', desc = '[G]it [S]tatus' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader>gl', function() Snacks.lazygit.log_file() end, desc = '[G]it [L]og (file)' },
    { '<leader>go', function() Snacks.gitbrowse() end, mode = { 'n', 'x' }, desc = '[G]it [O]pen in browser' },
  },
}
