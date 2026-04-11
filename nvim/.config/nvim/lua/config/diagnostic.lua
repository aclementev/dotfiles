vim.diagnostic.config({
  underline = false,
  virtual_text = true,
  float = { source = "if_many" },
  severity_sort = true,
})

vim.keymap.set("n", "<LocalLeader>dq", vim.diagnostic.setqflist, { silent = true })
vim.keymap.set("n", "<LocalLeader>dl", vim.diagnostic.setloclist, { silent = true })
