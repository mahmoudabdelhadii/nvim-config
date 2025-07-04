return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false,
  opts = {
    provider = 'claude',
    openai = {
      endpoint = 'https://api.openai.com/v1',
      model = 'gpt-4o',
      timeout = 30000,
      temperature = 0,
      max_completion_tokens = 8192,
    },
    claude = {
      endpoint = 'https://api.anthropic.com',
      model = 'claude-3-5-sonnet-20241022',
      timeout = 30000,
      temperature = 0.0,
      max_tokens = 8192,
    },
    gemini = {
      endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
      model = 'gemini-2.0-flash',
      timeout = 30000,
      temperature = 0.75,
      max_tokens = 8192,
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
          -- Add validation to prevent non-image content errors
          process_cmd = "magick convert - -quality 85 -",
          copy_images = false,
          download_images = false,
        },
        -- Only activate for markdown files to prevent unwanted triggers
        filetypes = {
          markdown = {
            url_encode_path = true,
            template = "![$CURSOR]($FILE_PATH)",
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
