-- Native LSP (vim.lsp.config / vim.lsp.enable). nvim-lspconfig only supplies
-- the base server configs; mason-lspconfig auto-enables whatever Mason installs.
local servers = {
  -- Web
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  cssls = {},
  tailwindcss = {},
  emmet_ls = { filetypes = { 'html', 'css', 'scss' } },

  -- Backend
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true, loadOutDirsFromCheck = true, runBuildScripts = true },
        checkOnSave = true,
        check = { allFeatures = true, command = 'clippy', extraArgs = { '--no-deps' } },
        procMacro = {
          enable = true,
          ignored = {
            ['async-trait'] = { 'async_trait' },
            ['napi-derive'] = { 'napi' },
            ['async-recursion'] = { 'async_recursion' },
          },
        },
      },
    },
  },
  elixirls = {},
  clangd = {},

  -- DevOps & config
  terraformls = {},
  dockerls = {},
  bashls = {},
  yamlls = {
    settings = { yaml = { schemaStore = { enable = false, url = '' } } },
    before_init = function(_, config)
      config.settings.yaml.schemas = require('schemastore').yaml.schemas()
    end,
  },
  jsonls = {
    settings = { json = { validate = { enable = true } } },
    before_init = function(_, config)
      config.settings.json.schemas = require('schemastore').json.schemas()
    end,
  },

  -- Lua (lazydev.nvim handles the Neovim runtime library)
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        hint = { enable = true, setType = true },
      },
    },
  },
}

-- Servers not managed by Mason
local external = {
  gleam = {},
  -- tsgo: native TypeScript LSP (@typescript/native-preview), handles TS/JS
  tsgo = {
    cmd = { 'tsgo', '--lsp', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  },
}

local tools = {
  -- Formatters
  'stylua',
  'prettierd',
  'ruff',
  'shfmt',
  -- Linters
  'eslint_d',
  'shellcheck',
}

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'b0o/schemastore.nvim',
    'saghen/blink.cmp',
  },
  config = function()
    vim.diagnostic.config {
      virtual_text = { spacing = 4, source = 'if_many', prefix = '●' },
      float = { border = 'rounded', source = true },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    }
    vim.o.winborder = 'rounded'

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- gd / gD / gr / gI / gy come from Snacks pickers (snacks.lua); K is native hover
        map('gi', function() Snacks.picker.lsp_implementations() end, '[G]o to [I]mplementation')
        map('gt', function() Snacks.picker.lsp_type_definitions() end, '[G]o to [T]ype definition')

        map('<leader>le', vim.diagnostic.open_float, '[L]anguage [E]rror')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>lh', vim.lsp.buf.hover, '[L]anguage [H]over')
        map('<leader>ls', vim.lsp.buf.signature_help, '[L]anguage [S]ignature')
        map('<leader>la', vim.lsp.buf.code_action, '[L]anguage [A]ction')
        map('<leader>ld', vim.diagnostic.setloclist, '[L]ist [D]iagnostics')
        map('[d', function() vim.diagnostic.jump { count = -1, float = true } end, 'Previous [D]iagnostic')
        map(']d', function() vim.diagnostic.jump { count = 1, float = true } end, 'Next [D]iagnostic')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>li', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
          end, '[L]anguage [I]nlay hints')
        end
      end,
    })

    -- blink.cmp capabilities for every server
    vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

    for name, cfg in pairs(vim.tbl_extend('error', servers, external)) do
      vim.lsp.config(name, cfg)
    end

    require('mason-tool-installer').setup {
      ensure_installed = vim.list_extend(vim.tbl_keys(servers), tools),
    }
    -- Prefer tsgo when installed (npm i -g @typescript/native-preview), else Mason's ts_ls
    local has_tsgo = vim.fn.executable 'tsgo' == 1
    require('mason-lspconfig').setup {
      -- stylua is a formatter here (conform), not an LSP
      automatic_enable = { exclude = has_tsgo and { 'ts_ls', 'stylua' } or { 'stylua' } },
    }
    for name, cfg in pairs(external) do
      local cmd = cfg.cmd or vim.lsp.config[name].cmd
      if type(cmd) ~= 'table' or vim.fn.executable(cmd[1]) == 1 then
        vim.lsp.enable(name)
      end
    end
  end,
}
