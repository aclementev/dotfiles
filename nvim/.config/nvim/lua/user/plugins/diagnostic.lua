vim.diagnostic.config {
  underline = false,
  signs = true,
  virtual_text = true,
  float = {
    -- TODO(alvaro): Test this
    -- show_header = true,
  },
  update_in_insert = false,
  severity_sort = true,
}

local opts = { silent = true }

vim.keymap.set("n", "<LocalLeader>dq", vim.diagnostic.setqflist, opts)
vim.keymap.set("n", "<LocalLeader>dl", vim.diagnostic.setloclist, opts)

return {
  {
    "folke/trouble.nvim",
    version = "3.*",
    lazy = false,
    dependencies = { "nvimdev/lspsaga.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Setup Lsp Saga configuration
      local saga_diag = require "lspsaga.diagnostic"

      vim.keymap.set("n", "<LocalLeader>dd", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
      -- vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
      -- vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
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

      -- Call setup
      require("trouble").setup()
    end,
    keys = {
      { "<Leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<Leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
      { "<Leader>xQ", "<cmd>Trouble quickfix toggle<CR>", desc = "QuickFix List (Trouble)" },
      { "<Leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
      { "<Leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "LSP Symbols (Trouble)" },
      { "<Leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP Definitions / references / ... (Trouble)" },
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
