-- Neovim builtin diagnostic setup
vim.diagnostic.config({
	underline = false,
	signs = true,
	virtual_text = true,
	float = {
		-- TODO(alvaro): Test this
		-- show_header = true,
	},
	update_in_insert = false,
	severity_sort = true,
})

-- Setup the Mappings
local map_opts = { noremap = true, silent = true }
local saga_diag = require("lspsaga.diagnostic")

vim.keymap.set("n", "<LocalLeader>dq", vim.diagnostic.setqflist, map_opts)
vim.keymap.set("n", "<LocalLeader>dl", vim.diagnostic.setloclist, map_opts)

-- Some LSP Saga related diagnostics
vim.keymap.set("n", "<LocalLeader>dd", saga_diag.show_line_diagnostics, map_opts)
vim.keymap.set("n", "<LocalLeader>dn", saga_diag.goto_next, map_opts)
vim.keymap.set("n", "<LocalLeader>dp", saga_diag.goto_prev, map_opts)
vim.keymap.set("n", "<LocalLeader>en", function()
	saga_diag.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, map_opts)
vim.keymap.set("n", "<LocalLeader>ep", function()
	saga_diag.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, map_opts)
