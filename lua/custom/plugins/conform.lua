return { -- Autoformat
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- No LSP fallback for languages without a standard style
      local no_lsp_fallback = { c = true, cpp = true }
      return {
        timeout_ms = 2500,
        lsp_format = no_lsp_fallback[vim.bo[bufnr].filetype] and 'never' or 'fallback',
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_organize_imports', 'ruff_format' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      yaml = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      html = { 'prettierd' },
      markdown = { 'prettierd' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
    },
  },
}
