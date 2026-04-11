-- General LSP configuration

-- Setup general settings for LSP servers
vim.lsp.config("*", {
  root_markers = { ".git", ".hg" },
})

-- Configure the list of servers that we want to always enable
local function get_python_lsp_server() return vim.env.ALVARO_PYTHON_LSP or "ty" end

local lsp_servers = {
  "lua_ls",
  "vimls",
  "gopls",
  "rust_analyzer",
  "ts_ls",
  get_python_lsp_server(),
}
vim.lsp.enable(lsp_servers)

-- LSP related Keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "[LSP] Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { silent = true, desc = "[LSP] Go to declaration" })
vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, { silent = true, desc = "[LSP] Signature Help" })
vim.keymap.set(
  "n",
  "gw",
  function() vim.lsp.buf.workspace_symbol(vim.fn.expand("<cword>")) end,
  { silent = true, desc = "[LSP] Find symbol under cursor in workspace" }
)
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, { silent = true, desc = "[LSP] Find symbol in workspace" })
vim.keymap.set(
  "n",
  "gh",
  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
  { silent = true, desc = "[LSP] Toggle Inlay Hints" }
)
vim.keymap.set(
  "n",
  "<Leader>wa",
  vim.lsp.buf.add_workspace_folder,
  { silent = true, desc = "[LSP] Add folder to workspace" }
)
vim.keymap.set(
  "n",
  "<Leader>wr",
  vim.lsp.buf.remove_workspace_folder,
  { silent = true, desc = "[LSP] Remove folder from workspace" }
)
vim.keymap.set(
  "n",
  "<Leader>wl",
  function() vim.print(vim.lsp.buf.list_workspace_folders()) end,
  { silent = true, desc = "[LSP] List workspace folders" }
)
