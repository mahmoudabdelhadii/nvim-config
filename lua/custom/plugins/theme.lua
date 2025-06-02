local theme_name = 'ayu'

if theme_name == 'rose-pine' then
  return { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'rose-pine/neovim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        disable_background = false,
        styles = {
          italic = false,
        },
      }

      vim.cmd 'colorscheme rose-pine-moon'
    end,
  }
end

if theme_name == 'ayu' then
  return {
    'Shatur/neovim-ayu',
    priority = 1000,
    opts = {
      mirage = false,
      overrides = {
        -- CursorLine = { bg = 'None' },
        Pmenu = { fg = '#FFF000' },
        Comment = { fg = '#b0c4de' },
        LineNr = { fg = '#778899' },
        Folded = { fg = '#6495ed' },
        FoldColumn = { fg = '#6495ed' },
      },
    },
    config = function(_, opts)
      require('ayu').setup(opts)
      vim.opt.termguicolors = true -- enable 24-bit RGB colors
      vim.cmd 'set background=dark'
      vim.cmd 'colorscheme ayu-mirage'
    end,
  }
end

if theme_name == 'jellybeans' then
  return {
    'wtfox/jellybeans.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  }
end

if theme_name == 'sonokai' then
  return {
    'sainnhe/sonokai',
    priority = 1000,
    config = function()
      -- vim.g.sonokai_enable_italic = true
      vim.g.sonokai_style = 'espresso'

      vim.cmd.colorscheme 'sonokai'
    end,
  }
end

if theme_name == 'tokyodark' then
  return {
    'tiagovla/tokyodark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyodark'
    end,
  }
end

if theme_name == 'zenbones' then
  return {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
    priority = 1000,
    config = function()
      -- zenwritten	Zero hue and saturation version
      -- neobones	Inspired by neovim.io
      -- vimbones	Inspired by vim.org
      -- rosebones	Inspired by Rosé Pine
      -- forestbones	Inspired by Everforest
      -- nordbones	Inspired by Nord
      -- tokyobones	Inspired by Tokyo Night
      -- seoulbones	Inspired by Seoul256
      -- duckbones	Inspired by Spaceduck
      -- zenburned	Inspired by Zenburn
      -- kanagawabones	Inspired by Kanagawa
      -- randombones	Randomly pick from the collection.
      -- vim.g.sonokai_enable_italic = true

      vim.cmd.colorscheme 'duckbones'
    end,
  }
end

if theme_name == 'oxocarbon' then
  return {
    'nyoom-engineering/oxocarbon.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'oxocarbon'
    end,
  }
end

if theme_name == 'tokyo' then
  return {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  }
end

if theme_name == 'kanagawa' then
  return {
    -- Or with configuration
    'rebelot/kanagawa.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Default options:
      require('kanagawa').setup {
        compile = false, -- enable compiling the colorscheme
        undercurl = false, -- enable undercurls
        commentStyle = { italic = false },
        functionStyle = { bold = true },
        keywordStyle = { italic = false, bold = true },
        statementStyle = { bold = true },
        typeStyle = { bold = true },
        transparent = false, -- do not set background color
        dimInactive = true, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = 'wave', -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = 'wave', -- try "dragon" !
          light = 'lotus',
        },
      }

      -- setup must be called before loading
      vim.cmd 'colorscheme kanagawa'
    end,
  }
end

if theme_name == 'everforest' then
  return {
    'neanias/everforest-nvim',
    priority = 1000,

    config = function()
      vim.opt.background = 'dark'
      require('everforest').setup {
        ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
        ---Default is "medium".
        background = 'hard',
        ---How much of the background should be transparent. 2 will have more UI
        ---components be transparent (e.g. status line background)
        transparent_background_level = 0,
        ---Whether italics should be used for keywords and more.
        italics = false,
        ---Disable italic fonts for comments. Comments are in italics by default, set
        ---this to `true` to make them _not_ italic!
        disable_italic_comments = false,
        ---By default, the colour of the sign column background is the same as the as normal text
        ---background, but you can use a grey background by setting this to `"grey"`.
        sign_column_background = 'none',
        ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
        ---`"low"` (default).
        ui_contrast = 'high',

        vim.cmd [[colorscheme everforest]],
      }
    end,
  }
end

if theme_name == 'forest2' then
  return {
    'comfysage/evergarden',
    priority = 1000,
    opts = {
      transparent_background = false,
      variant = 'medium', -- 'hard'|'medium'|'soft'
      overrides = {}, -- add custom overrides
    },
  }
end

if theme_name == 'catppuccin' then
  return {
    'catppuccin/nvim',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'auto', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  }
end
