return {
  "nvim-neotest/nvim-nio",
  {
    "nvim-neotest/neotest",
    version = "5.*",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
        },
      })
    end,
    keys = {
      { "<Leader>tt", function() require("neotest").run.run() end, desc = "Test: Run nearest" },
      { "<Leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run file" },
      { "<Leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test: Run all" },
      { "<Leader>tl", function() require("neotest").run.run_last() end, desc = "Test: Run last" },
      { "<Leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Test: Toggle watch" },
      {
        "<Leader>to",
        function() require("neotest").output.open({ enter = true, auto_close = true }) end,
        desc = "Test: Open output",
      },
      { "<Leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test: Toggle output panel" },
      { "<Leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: Toggle summary" },
      { "<Leader>tS", function() require("neotest").run.stop() end, desc = "Test: Stop" },
      { "<Leader>tD", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug nearest" },
    },
  },
}
