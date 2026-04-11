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
}
