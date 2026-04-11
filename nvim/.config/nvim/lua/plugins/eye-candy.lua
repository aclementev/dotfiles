return {
  -- Pretty Icons, used by plugins
  { "nvim-mini/mini.icons", version = "*" },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  -- Vertical markers for indentation level
  {
    "nvim-mini/mini.indentscope",
    version = "*",
    opts = {
      symbol = "│",
    },
  },
  -- Cursor "smear" animation (neovide style)
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      cursor_color = "none",
      vertical_bar_cursor_insert_mode = true,
      legacy_computing_symbols_support = true,
    },
  },
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = "padded_slant",
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    },
  },
}
