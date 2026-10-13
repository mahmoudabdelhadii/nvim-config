return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPost', 'BufWritePost' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      sh = { 'shellcheck' },
      bash = { 'shellcheck' },
    }

    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('user-lint', { clear = true }),
      callback = function()
        if not vim.bo.modifiable then
          return
        end
        -- Only run linters whose binary exists (e.g. eslint_d needs a project config)
        local names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          local cmd = type(linter) == 'table' and linter.cmd or name
          cmd = type(cmd) == 'function' and cmd() or cmd
          return vim.fn.executable(cmd) == 1
        end, lint.linters_by_ft[vim.bo.filetype] or {})
        lint.try_lint(names)
      end,
    })
  end,
}
