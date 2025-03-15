return {
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup{
        -- NOTE(alvaro): These contain most of the default keymaps, removing ones that 
        -- I don't want (i.e. <C-h>)
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          -- This is a modification of the default <C-h> one
          ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = { "actions.close", mode = "n" },
          -- This is a modification of the default <C-l> one
          ["<C-r>"] = "actions.refresh",
          ["-"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gx"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        use_default_keymaps = false
      }
    end
  },
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
    opts = {
      menu = {
        width = 120,
        height = 20,
      }
    },
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
