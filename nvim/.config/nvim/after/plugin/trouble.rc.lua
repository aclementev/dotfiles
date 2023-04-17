local status, trouble = pcall(require, "trouble")
if not status then
	return
end

trouble.setup({})

-- Setup Keybinds
vim.keymap.set("n", "<Leader>xx", "<cmd>TroubleToggle<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Leader>xl", "<cmd>TroubleToggle loclist<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Leader>xq", "<cmd>TroubleToggle quickfix<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Leader>xr", "<cmd>TroubleToggle lsp_references<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Leader>xn", function()
	require("trouble").next({ skip_groups = true, jump = true })
end, { silent = true, noremap = true })
vim.keymap.set("n", "<Leader>xp", function()
	require("trouble").previous({ skip_groups = true, jump = true })
end, { silent = true, noremap = true })
