local setup, nvim_tree = pcall(require, "nvim-tree")
if not setup then
	return
end

local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	-- Custom mappings
	vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
end

nvim_tree.setup({
	sort_by = "case_sensitive",
	view = {
		adaptive_size = true,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})

-- Mappings for NvimTree
vim.keymap.set("n", "<Leader>b", function()
	vim.cmd("NvimTreeToggle")
end)
