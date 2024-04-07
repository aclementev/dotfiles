return {
  {
    "chomosuke/term-edit.nvim",
    lazy = false,
    version = "1.*",
    opts = {
      -- NOTE(alvaro): This is how this detects the end of the prompt, so you must set it
      prompt_end = "❯ ",
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = "<Leader>to",
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
      { "<Leader>tv", ":ToggleTerm direction=vertical<CR>", desc = "Open Toggleterm in a vertical split" },
      { "<Leader>tx", ":ToggleTerm direction=horizontal<CR>", desc = "Open Toggleterm in a horizontal split" },
      { "<Leader>tl", ":ToggleTermSendCurrentLine<CR>", desc = "Send current line to Toggleterm" },
      { "<Leader>tl", ":ToggleTermSendCurrentVisualSelection<CR>", desc = "Send current line to Toggleterm", mode = "v" },
    },
  },
}
