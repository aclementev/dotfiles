return {
  {
    "folke/trouble.nvim",
    version = "3.*",
    lazy = false,
    dependencies = { "nvimdev/lspsaga.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Call setup
      require("trouble").setup()
    end,
    keys = {
      { "<Leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<Leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
      { "<Leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "QuickFix List (Trouble)" },
      { "<Leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
      { "<Leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "LSP Symbols (Trouble)" },
      {
        "<Leader>xd",
        "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      { "<Leader>xr", "<cmd>Trouble lsp toggle<CR>", desc = "Open LSP References on Trouble" },
      {
        "<Leader>xn",
        function()
          require("trouble").next { skip_groups = true, jump = true }
        end,
        desc = "Jump to next element in Trouble",
      },
      {
        "<Leader>xp",
        function()
          require("trouble").prev { skip_groups = true, jump = true }
        end,
        desc = "Jump to previous element in Trouble",
      },
    },
  },
}
