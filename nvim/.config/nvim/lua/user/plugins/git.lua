return {
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      numhl = true,
    },
    keys = {
      {
        "<LocalLeader>gs",
        function()
          require("gitsigns").stage_hunk()
        end,
        desc = "Git: Stage Hunk",
      },
      {
        "<LocalLeader>gr",
        function()
          require("gitsigns").reset_hunk()
        end,
        desc = "Git: Restore Hunk",
      },
      {
        "<LocalLeader>gs",
        function()
          require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end,
        mode = "v",
        desc = "Git: Stage visual selection",
      },
      {
        "v",
        "<LocalLeader>gr",
        function()
          require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end,
        desc = "Git: Restore visual selection",
      },
      {
        "<LocalLeader>gS",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "Git: Stage Buffer",
      },
      {
        "<LocalLeader>gR",
        function()
          require("gitsigns").reset_buffer()
        end,
        desc = "Git: Restore Buffer",
      },
      {
        "<LocalLeader>gu",
        function()
          require("gitsigns").undo_stage_hunk()
        end,
        desc = "Git: Undo stage hunk",
      },
      {
        "<LocalLeader>gP",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Git: Preview Hunk",
      },
      {
        "<LocalLeader>gb",
        function()
          require("gitsigns").blame_line { full = true }
        end,
        desc = "Git: Blame Line",
      },
      {
        "<LocalLeader>tb",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = ":Git: Toggle Current Line Blame",
      },
      {
        "<LocalLeader>gd",
        function()
          require("gitsigns").diffthis()
        end,
        desc = "Git: Diff current file against index",
      },
      {
        "<LocalLeader>gD",
        function()
          require("gitsigns").diffthis "~1"
        end,
        desc = "Git: Diff current file against previous commit",
      },
      {
        "<LocalLeader>td",
        function()
          require("gitsigns").toggle_deleted()
        end,
        desc = "Git: Toggle Deleted (?)",
      },
      -- Text Object
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git: Hunk text object" },
    },
  },
}
