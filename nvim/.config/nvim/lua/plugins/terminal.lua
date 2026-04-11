return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      autochdir = true,
      insert_mappings = false,
      terminal_mappings = false,
      direction = "float",
      shade_terminals = false,
      size = function(term)
        if term.direction == "horizontal" then return 15 end
        if term.direction == "vertical" then return vim.o.columns * 0.4 end
      end,
    },
    keys = {
      { "<LocalLeader>to", "<cmd>ToggleTerm<CR>", desc = "Toggle floating terminal" },
      { "<LocalLeader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle vertical terminal" },
      { "<LocalLeader>tx", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle horizontal terminal" },
      { "<LocalLeader>tl", "<cmd>ToggleTermSendCurrentLine<CR>", desc = "Send current line to Toggleterm" },
      {
        "<LocalLeader>tl",
        "<cmd>ToggleTermSendVisualSelection<CR>",
        desc = "Send visual selection to Toggleterm",
        mode = "v",
      },
    },
  },
}
