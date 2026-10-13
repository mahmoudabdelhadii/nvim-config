return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    opts = {},
  },
  {
    'HakonHarnes/img-clip.nvim',
    ft = 'markdown',
    keys = { { '<leader>ip', '<cmd>PasteImage<cr>', desc = 'Paste image from clipboard' } },
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        use_absolute_path = true,
        drag_and_drop = { insert_mode = true },
      },
      filetypes = {
        markdown = { url_encode_path = true, template = '![$CURSOR]($FILE_PATH)' },
      },
    },
  },
}
