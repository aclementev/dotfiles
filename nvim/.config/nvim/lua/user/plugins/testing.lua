-- TODO(alvaro): Review the testing setup
return {
  "nvim-neotest/nvim-nio",
  "antoinemadec/FixCursorHold.nvim",
  "nvim-neotest/neotest-python",
  "nvim-neotest/neotest-plenary",
  "nvim-neotest/neotest-go",
  "nvim-neotest/neotest-vim-test", -- For any other language without an adapter, use vim-test
  "vim-test/vim-test",
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-python" {
            dap = { justMyCode = false },
          },
          require "neotest-plenary" {},
          require "neotest-vim-test" {
            ignore_file_types = { "python", "lua", "go" },
          },
        },
      }
    end,
    keys = {
      {
        "<Leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: Run nearest test",
        silent = true,
      },
      {
        "<Leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Test: Run all tests",
        silent = true,
      },
      {
        "<Leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Test: Run all tests in file",
        silent = true,
      },
      {
        "<Leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test: Run last test",
        silent = true,
      },
      {
        "<Leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test: Open Output",
        silent = true,
      },
      {
        "<Leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test: Toggle Output panel",
        silent = true,
      },
      {
        "<Leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: Toggle Summary",
        silent = true,
      },
      {
        "<Leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test: Stop tests",
        silent = true,
      },
    },
  },
}
