return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      log_level = vim.log.levels.INFO,
    },
  },
  -- To inform LSP servers about file operations (moved, deleted) performed from nvim
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lspsaga").setup {
        lightbulb = {
          enable = false,
        },
      }
      -- Setup diagnostics
      local saga_diag = require "lspsaga.diagnostic"

      vim.keymap.set("n", "<LocalLeader>dd", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
      vim.keymap.set("n", "]e", function()
        saga_diag:goto_next { severity = vim.diagnostic.severity.ERROR }
      end, opts)
      vim.keymap.set("n", "[e", function()
        saga_diag:goto_prev { severity = vim.diagnostic.severity.ERROR }
      end, opts)
      vim.keymap.set("n", "]w", function()
        saga_diag:goto_next { severity = vim.diagnostic.severity.WARN }
      end, opts)
      vim.keymap.set("n", "[w", function()
        saga_diag:goto_prev { severity = vim.diagnostic.severity.WARN }
      end, opts)
    end,
  },
  -- LSP Progress notifications
  "j-hui/fidget.nvim",
}
