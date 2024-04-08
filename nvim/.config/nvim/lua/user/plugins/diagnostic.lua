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
    version = "2.*",
    lazy = false,
    dependencies = { "nvimdev/lspsaga.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Setup Lsp Saga configuration
      local saga_diag = require "lspsaga.diagnostic"

      vim.keymap.set("n", "<LocalLeader>dd", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
      vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
      vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
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
    keys = {
      { "<Leader>xx", "<cmd>TroubleToggle<CR>", desc = "Toggle Trouble" },
      { "<Leader>xw", "<cmd>TroubleToggle workspace_diagnostic<CR>", desc = "Toggle Trouble Workspace Diagnostics" },
      { "<Leader>xd", "<cmd>TroubleToggle document_diagnostic<CR>", desc = "Toggle Trouble Document Diagnostics" },
      { "<Leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "Send Trouble to Quickfix List" },
      { "<Leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "Send Trouble to Location List" },
      { "<Leader>xr", "<cmd>TroubleToggle lsp_references<CR>", desc = "Open LSP References on Trouble" },
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
          require("trouble").previous { skip_groups = true, jump = true }
        end,
        desc = "Jump to previous element in Trouble",
      },
    },
  },
}
