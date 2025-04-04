-- Basic LSP configuration
local M = {}

-- TODO(alvaro): Should we just set these up every time
-- Mappings
local lsp_mappings = {
  { "n", "gd", vim.lsp.buf.definition },
  { "n", "gD", vim.lsp.buf.declaration },
  -- @deprecated in 0.11 by builtin `gri`
  -- {"n", "gi", vim.lsp.buf.implementation},
  { "n", "grt", vim.lsp.buf.type_definition },
  { "n", "gk", vim.lsp.buf.signature_help },
  {
    "n",
    "gw",
    function()
      local cword = vim.fn.expand "<cword>"
      vim.lsp.buf.workspace_symbol(cword)
    end,
  },
  { "n", "gW", vim.lsp.buf.workspace_symbol },
  {
    "n",
    "gh",
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end,
  },
  -- @deprecated in 0.11 by builtin <C-S>
  -- {"i", "<C-H>", vim.lsp.buf.signature_help}
  { "n", "<Leader>wa", vim.lsp.buf.add_workspace_folder },
  { "n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder },
  {
    "n",
    "<Leader>wl",
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
  },
  -- LspSaga related commands
  -- There's a builtin alternative `gra`, although the UI is less nice
  { "n", "<LocalLeader>ca", "<cmd>Lspsaga code_action<CR>" },
  { "v", "<LocalLeader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>" },
  { "n", "<LocalLeader>rn", "<cmd>Lspsaga rename<CR>" },
  { "n", "<LocalLeader>rN", "<cmd>Lspsaga rename ++project<CR>" },
  { "n", "gp", "<cmd>Lspsaga preview_definition<CR>" },
  -- TODO(alvaro): Do this all in a custom command in lua, now is a bit flickery
  { "n", "gs", ":vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>zz" },
  { "n", "gx", ":sp<CR><cmd>lua vim.lsp.buf.definition()<CR>zz" },
}

-- TODO(alvaro): Figure out if we can mvoe these to static `lsp/<name>.lua` based configurations
-- At the moemnt I don't think we can since we would depend on `nvim-lspconfig` which is a plugin

-- Setup the LSP configuration using Neovim builtin LSP config protocol
M.setup = function()
  -- TODO(alvaro): Figure out how to configure stuff using these there, not by
  -- using `nvim-lspconfig.setup(opts)`
  -- local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  -- local basic_capabilities = {
  --   textDocument = {
  --     semanticTokens = {
  --       multilineTokenSupport = true,
  --     },
  --   },
  -- }
  -- local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  -- local common_capabilities = vim.tbl_deep_extend("force", default_capabilities, basic_capabilities, cmp_capabilities)

  -- Default configuration to be shared by all servers
  -- vim.lsp.config("*", {
  --   root_markers = { ".git", ".hg" },
  --   capabilities = common_capabilities,
  --   flags = {
  --     -- FIXME(alvaro): Not sure which servers actually use this
  --     debounce_text_changes = 150,
  --   },
  -- })

  -- FIXME(alvaro): List of LSP servers to enable
  -- vim.lsp.enable {}

  -- Add LspAttach handler
  local augroup = vim.api.nvim_create_augroup("alvaro.lsp.config", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    desc = "Setting up LSP for buffer",
    callback = function(ev)
      -- Setup the mappings
      for _, map_opts in ipairs(lsp_mappings) do
        vim.keymap.set(map_opts[1], map_opts[2], map_opts[3], { buffer = ev.buf, silent = true })
      end
    end,
  })
end

return M
