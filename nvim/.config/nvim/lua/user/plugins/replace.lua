return {
  {
    "MagicDuck/grug-far.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- By default it uses 4 workers but we have more cores!
      -- maxWorkers = ...,
      keymaps = {
        -- FIXME(alvaro): For some reason this does not work
        -- replace = { n = "<CR>" },
        qflist = { n = "<C-q>" },
        nextInput = { i = "<Tab>" },
        prevInput = { i = "<S-Tab>" },
      },
    },
    keys = {
      {
        "<Leader>sr",
        function()
          require("grug-far").open { transient = true }
        end,
        desc = "Search and Replace",
      },
      {
        "<Leader>sa",
        function()
          require("grug-far").open { engine = "astgrep", transient = true }
        end,
        desc = "Search and Replace",
      },
    },
  },
}
