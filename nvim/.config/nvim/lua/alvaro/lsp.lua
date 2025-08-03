-- Basic LSP configuration
local M = {}

-- TODO(alvaro): Figure out how we want to handle languages with multiple language servers (e.g. Python)
-- There are several options that I can think of, depending on what vim.lsp.config/vim.lsp.enable actually supports
-- Can we have all of the servers "enabled" and somehow select which one to enable on buffer attach?
-- Options that I can think of:
--    - Pick a default, use env vars to override
--    - Pick a default, use .nvim.lua local file to override (at runtime)
--    - Don't pick a default, try to read common project config files and guess which one we should use
--      based on which of them are configured (e.g. pyproject.toml with mypy config)

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

-- Get which LSP server we should use for the current project
-- By default we use `pylsp`, but we can use others
-- TODO(alvaro): try to guess based on the project's config if there's no override
-- set by
-- You can trivially override this permanently for a project using `.nvim.lua` file
--    ```lua
--    vim.lsp.enable("pylsp", false)
--    vim.lsp.enable("ty")
--    ```
M.get_configured_python_lsp = function()
  local override = vim.fn.getenv "ALVARO_USE_TY"
  if override == "1" then
    return "ty"
  end
  return "pylsp"
end

-- Setup the LSP configuration using Neovim builtin LSP config protocol
M.setup = function()
  -- Check if we are ready to configure LSP, which requires extra plugins to be installed
  -- FIXME(alvaro): Do we really require plugins at this point? or can we just reduce
  -- the capabilities and continue working
  local ok, _ = pcall(require, "blink.cmp")
  if not ok then
    vim.notify("The plugins are not setup", vim.log.levels.ERROR)
    return
  end

  -- Prepare the capabilities
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  local basic_capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  }
  -- FIXME(alvaro): According to blink this may not be necessary anymore?
  local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
  local file_capabilities = require("lsp-file-operations").default_capabilities()
  local common_capabilities =
    vim.tbl_deep_extend("force", default_capabilities, basic_capabilities, blink_capabilities, file_capabilities)

  vim.lsp.config("*", {
    root_markers = { ".git", ".hg" },
    capabilities = common_capabilities,
  })

  local lsp_servers = {
    "lua_ls",
    "vimls",
    "gopls",
    "rust_analyzer",
    "pylsp",
    M.get_configured_python_lsp(),
  }
  -- TODO(alvaro): Figure out a better way of selecing the right server for languages
  -- that support many and we may change per project (i.e. env var? .nvim.lua file?)
  -- TODO(alvaro): Can we have multiple servers enabled, and have the on attach buffer
  -- pick only one based on the buffer? or do we need to globally configure one for the
  -- whole nvim session as we do now

  vim.lsp.enable(lsp_servers)

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

      -- Fix an issue where the semantic token highlighting for comments overrides the nice comment tag
      -- highlights introduced by `treesitter-comment`
      vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
    end,
  })
end

return M
