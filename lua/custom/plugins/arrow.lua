return {
  'otavioschwanck/arrow.nvim',
  opts = {
    show_icons = false,
    index_keys = 'asdfhjklzxcvnm,.',
    leader_key = ';', -- Recommended to be a single key
    buffer_leader_key = 'm', -- Per Buffer Mappings
    mappings = {
      edit = 'e',
      delete_mode = 'D',
      clear_all_items = 'C',
      toggle = 'S', -- used as save if separate_save_and_remove is true
      open_vertical = 'V',
      open_horizontal = '-',
      quit = 'Q',
      remove = 'X', -- only used if separate_save_and_remove is true
      next_item = ';',
      prev_item = ':',
    },
  },
}
