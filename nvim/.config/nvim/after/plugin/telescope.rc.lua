local status, telescope = pcall(require, "telescope")
if not status then
	return
end

local builtin = require("telescope.builtin")

-- Find files in directory
local function find_in_dir(dir)
	return builtin.find_files({ search_dirs = { dir } })
end

-- Generates a function that will call find appending a set of hardcoded
-- excludes (useful when not in a git repo with a .gitignore)
local function fd_with_excludes(excludes)
	local exclude_tbl = {}
	for _, dir in ipairs(excludes) do
		table.insert(exclude_tbl, "--exclude")
		table.insert(exclude_tbl, dir)
	end
	local find_options = {
		find_command = vim.list_extend({ "fd", "--type", "f" }, exclude_tbl),
		follow = true,
		hidden = true,
	}
	return function()
		return builtin.find_files(find_options)
	end
end

DIRS_TO_IGNORE = {
	".git",
	"node_modules",
	".mypy_cache",
	".pytest_cache",
	"__pycache__",
}
local fd_all_with_excludes = fd_with_excludes(DIRS_TO_IGNORE)

-- TODO(alvaro): Review Telescope options
telescope.setup({
	defaults = {
		path_display = {
			"truncate",
			-- "shorten",
			-- "smart",
		},
		mappings = {
			-- i = {
			--     ["<c-j>"] = "move_selection_next",
			--     ["<c-k>"] = "move_selection_previous",
			-- }
		},
	},
	extensions = {
		["ui-select"] = {
			-- FIXME(alvaro): Review this
			require("telescope.themes").get_dropdown({
				-- Any DropDown options
			}),
		},
		file_browser = {
			theme = "dropdown",
			-- hijack_netrw = true,
			mappings = {
				i = {
					["<C-W>"] = function()
						vim.cmd("normal db")
					end,
				},
			},
		},
	},
})

-- This requires an external installation to work properly:
-- https://github.com/nvim-telescope/telescope-fzy-native.nvim
telescope.load_extension("fzy_native")
telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

local opts = { silent = true }

-- -- TODO(alvaro): Maybe we want to show_untracked here?
vim.keymap.set("n", "<Leader>ff", function()
	return builtin.git_files({ show_untracked = false })
end, opts)
-- TODO(alvaro): Make this mapping default to `find` if `fd` is not installed
vim.keymap.set("n", "<Leader>fa", fd_all_with_excludes, opts)
vim.keymap.set("n", "<Leader>fA", function()
	return builtin.find_files({
		find_command = { "fd", "--type", "f", "--exclude", ".git" },
		follow = true,
		hidden = true,
		no_ignore = true,
	})
end, opts)
vim.keymap.set("n", "<Leader>fb", builtin.buffers, opts)
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, opts)
vim.keymap.set("n", "<Leader>fo", builtin.oldfiles, opts)
vim.keymap.set("n", "<Leader>fC", builtin.commands, opts)
vim.keymap.set("n", "<Leader>fz", builtin.current_buffer_fuzzy_find, opts)
vim.keymap.set("n", "<Leader>fc", function()
	return find_in_dir("~/.config/nvim")
end, opts)
vim.keymap.set("n", "<Leader>fD", function()
	return find_in_dir("~/dotfiles")
end, opts)
-- Telescope + LSP
vim.keymap.set("n", "<Leader>fs", builtin.lsp_document_symbols, opts)
vim.keymap.set("n", "<Leader>fS", builtin.lsp_workspace_symbols, opts)
vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, opts)
vim.keymap.set("n", "<Leader>fd", function()
	return builtin.diagnostics({ bufnr = 0 })
end, opts)
vim.keymap.set("n", "<Leader>fD", builtin.diagnostics, opts)
-- Telescope + Grep
vim.keymap.set("n", "<Leader>g", builtin.grep_string, opts)
vim.keymap.set("n", "<Leader>r", builtin.live_grep, opts)

-- Setup Telescope File Browser
vim.keymap.set("n", "<Leader>ft", function()
	telescope.extensions.file_browser.file_browser({
		-- path = "%:p:h",  -- Open withing the curren buffer
		-- respect_gitignore = false,
		hidden = true,
		grouped = true,
		previewer = false,
		initial_mode = "normal",
		layout_config = {
			height = 40,
		},
	})
end, opts)
