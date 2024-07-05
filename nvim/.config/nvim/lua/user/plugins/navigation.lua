return {
  "stevearc/oil.nvim",
  {
    "nvim-tree/nvim-tree.lua",
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      sort_by = "case_sensitive",
      view = {
        side = "right",
        adaptive_size = true,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    },
    keys = {
      { "<Leader>b", ":NvimTreeFindFileToggle<CR>", desc = "Open NvimTree on the current file" },
    },
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<LocalLeader>ha",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon: Add file",
      },
      {
        "<LocalLeader>hh",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Harpoon: Open Quick Menu",
      },
      {
        "<LocalLeader>hn",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Harpoon: Navigate to next",
      },
      {
        "<LocalLeader>hp",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Harpoon: Navigate to previous",
      },
      {
        "<LocalLeader>1",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "Harpoon: Navigate to entry #1",
      },
      {
        "<LocalLeader>2",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "Harpoon: Navigate to entry #2",
      },
      {
        "<LocalLeader>3",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "Harpoon: Navigate to entry #3",
      },
      {
        "<LocalLeader>4",
        function()
          require("harpoon.ui").nav_file(4)
        end,
        desc = "Harpoon: Navigate to entry #4",
      },
      {
        "<LocalLeader>5",
        function()
          require("harpoon.ui").nav_file(5)
        end,
        desc = "Harpoon: Navigate to entry #5",
      },
    },
  },
}
