vim.diagnostic.config {
  underline = false,
  signs = true,
  virtual_text = true,
  -- TODO(alvaro): Figure out some way to toggle this becasue by default is jumpy
  -- virtual_lines = {
  --   current_line = true,
  -- },
  float = {
    source = "if_many",
    border = "rounded",
  },
  update_in_insert = false,
  severity_sort = true,
}

local opts = { silent = true }

vim.keymap.set("n", "<LocalLeader>dq", vim.diagnostic.setqflist, opts)
vim.keymap.set("n", "<LocalLeader>dl", vim.diagnostic.setloclist, opts)
