return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },
    -- LSP capabilities for completion
    'hrsh7th/cmp-nvim-lsp',
    -- JSON schemas
    'b0o/schemastore.nvim',
  },
  config = function()
    -- Enhanced diagnostics configuration
    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        source = 'if_many',
        prefix = '●',
      },
      float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Enhanced floating window borders
    local border = {
      { '╭', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╮', 'FloatBorder' },
      { '│', 'FloatBorder' },
      { '╯', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╰', 'FloatBorder' },
      { '│', 'FloatBorder' },
    }

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or border
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    require('lspconfig').gleam.setup {}

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Essential LSP navigation
        map('gd', vim.lsp.buf.definition, '[G]o to [D]efinition')
        map('gD', vim.lsp.buf.declaration, '[G]o to [D]eclaration')
        map('gi', vim.lsp.buf.implementation, '[G]o to [I]mplementation')
        map('gt', vim.lsp.buf.type_definition, '[G]o to [T]ype definition')
        map('gr', vim.lsp.buf.references, '[G]o to [R]eferences')
        
        -- Language features
        map('<leader>le', vim.diagnostic.open_float, '[L]anguage [E]rror')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>lh', vim.lsp.buf.hover, '[L]anguage [H]over')
        map('<leader>ls', vim.lsp.buf.signature_help, '[L]anguage [S]ignature')
        
        -- Diagnostics navigation
        map('[d', vim.diagnostic.goto_prev, 'Previous [D]iagnostic')
        map(']d', vim.diagnostic.goto_next, 'Next [D]iagnostic')
        map('<leader>ld', vim.diagnostic.setloclist, '[L]ist [D]iagnostics')


        local client = vim.lsp.get_client_by_id(event.data.client_id)
        map('<leader>la', function()
          vim.lsp.buf.code_action()
        end, '[L]anguage [A]ction')

        if client then
          vim.api.nvim_create_user_command('ToggleInlayHints', function()
            if vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            else
              vim.notify 'No inlay hints available'
            end
          end, {})
        end
        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>li', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[L]anguage [I]nlay')
        end
      end,
    })

    -- Enable the following language servers. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- Web Development
      ts_ls = {
        format = false,
        settings = {
          javascript = {
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = false,
            },
          },
          typescript = {
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = false,
            },
          },
        },
      },
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      tailwindcss = {},
      emmet_ls = {
        filetypes = { 'html', 'css', 'scss' },
      },

      -- Backend Languages
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
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = {
              allFeatures = true,
              command = 'clippy',
              extraArgs = { '--no-deps' },
            },
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

      -- DevOps & Config
      terraformls = {},
      dockerls = {},
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
              ['https://json.schemastore.org/github-action.json'] = '/action.{yml,yaml}',
              ['https://json.schemastore.org/docker-compose.json'] = 'docker-compose*.{yml,yaml}',
              ['https://json.schemastore.org/kustomization.json'] = 'kustomization.{yml,yaml}',
            },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },

      -- Shell & System
      bashls = {},
      
      -- Other Languages
      elixirls = {},
      clangd = {},
      
      -- Lua (Neovim config)
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            hint = { enable = true, setType = true },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.stdpath('config') .. '/lua'] = true,
              },
            },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      -- Formatters
      'stylua',
      'prettierd',
      'prettier',
      'black',
      'isort',
      'rustfmt',
      'shfmt',
      
      -- Linters
      'shellcheck',
      'eslint_d',
      'ruff',
      
      -- Additional tools
      'tailwindcss-language-server',
      'emmet-ls',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    local capabilities = vim.tbl_deep_extend(
      'force',
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
    )

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
