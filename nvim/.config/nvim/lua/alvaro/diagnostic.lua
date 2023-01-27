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

vim.keymap.set("n", "<LocalLeader>dq", vim.diagnostic.setqflist, map_opts)
vim.keymap.set("n", "<LocalLeader>dl", vim.diagnostic.setloclist, map_opts)

-- Some LSP Saga related diagnostics
local status, saga_diag = pcall(require, "lspsaga.diagnostic")
if status then
	vim.keymap.set("n", "<LocalLeader>dd", "<cmd>Lspsaga show_line_diagnostics<CR>", map_opts)
	vim.keymap.set("n", "<LocalLeader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", map_opts)
	vim.keymap.set("n", "<LocalLeader>dp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", map_opts)
	vim.keymap.set("n", "<LocalLeader>en", function()
		saga_diag:goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, map_opts)
	vim.keymap.set("n", "<LocalLeader>ep", function()
		saga_diag:goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, map_opts)
end
