return {
  'saghen/blink.cmp',
  dependencies = { 
    'rafamadriz/friendly-snippets',
    'L3MON4D3/LuaSnip',
  },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    signature = { enabled = true },
    keymap = { 
      preset = 'enter',
      ['<Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
    },

    cmdline = { 
      enabled = true,
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == '/' or type == '?' then
          return { 'buffer' }
        end
        if type == ':' then
          return { 'cmdline' }
        end
        return {}
      end,
    },

    appearance = {
      nerd_font_variant = 'mono',
      kind_icons = {
        Text = '󰉿',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰜢',
        Variable = '󰀫',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '󰑭',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '󰈇',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '󰙅',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '',
      },
    },

    completion = { 
      documentation = { 
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'single',
          max_width = 80,
          max_height = 20,
        } 
      },
      ghost_text = {
        enabled = true,
      },
      menu = {
        enabled = true,
        min_width = 15,
        max_height = 10,
        border = 'single',
        winblend = 0,
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        }
      },
      list = {
        selection = { preselect = true },
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lsp = {
          min_keyword_length = 1,
          score_offset = 90,
        },
        buffer = {
          min_keyword_length = 2,
          max_items = 5,
          score_offset = 15,
        },
        snippets = {
          min_keyword_length = 1,
          score_offset = 85,
        },
        path = {
          score_offset = 25,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            show_hidden_files_by_default = true,
          },
        },
      },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}