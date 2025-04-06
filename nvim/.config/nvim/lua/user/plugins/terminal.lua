return {
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    opts = {
      open_mapping = "<LocalLeader>to",
      hide_numbers = true,
      autochdir = true,
      start_in_insert = true,
      insert_mappings = false,
      terminal_mappings = false,
      direction = "float",
      close_on_exit = true,
      auto_scroll = true,
      float_opts = {
        border = "curved",
      },
      winbar = {
        enabled = false,
      },
    },
    keys = {
      { "<LocalLeader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Open Toggleterm in a vertical split" },
      { "<LocalLeader>tx", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Open Toggleterm in a horizontal split" },
      { "<LocalLeader>tl", "<cmd>ToggleTermSendCurrentLine<CR>", desc = "Send current line to Toggleterm" },
      { "<LocalLeader>tl", "<cmd>ToggleTermSendCurrentVisualSelection<CR>", desc = "Send current line to Toggleterm", mode = "v" },
    },
  },
}
