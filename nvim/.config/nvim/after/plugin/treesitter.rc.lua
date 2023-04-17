local status, tsconfigs = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

tsconfigs.setup({
	ensure_installed = {
		"clojure",
		"comment",
        "elixir",
        "gitcommit",
        "gitignore",
        "go",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"rust",
		"typescript",
		"vim",
		"vue",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		-- Enable this if we see that this is too broken for now
		additional_vim_regex_highlighting = false,
	},
	indent = {
		-- NOTE: This is still experimental
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn", -- set to `false` to disable one of the mappings
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	-- nvim-treesiter/playground config
	playground = {
		enable = true,
	},
	-- nvim-treesiter/nvim-treesitter-textobjects config
	textobjects = {
		select = {
			enable = true,
			-- You can use capture groups defined in textobjects.scm
			keymaps = {
				["if"] = "@function.inner",
				["af"] = "@function.outer",
				["ic"] = "@class.inner",
				["ac"] = "@class.outer",
				["ia"] = "@parameter.inner",
				["aa"] = "@parameter.outer",
				["ib"] = "@block.inner",
				["ab"] = "@block.outer",
			},
            include_surrounding_whitespace = true
		},
		swap = {
			enable = true,
			swap_next = {
				["<Leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<Leader>A"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[]"] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[["] = "@class.outer",
			},
		},
	},
})
