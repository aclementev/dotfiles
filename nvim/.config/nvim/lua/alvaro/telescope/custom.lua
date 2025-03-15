local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

-- Custom pickers for Telescope
local M = {}

-- A modification of live_grep picker that can optionally take a set of file patterns
-- to narrow the search
-- Inspired by tjdevries' video: https://www.youtube.com/watch?v=xdXE1tOT-qg
M.live_multigrep = function(opts)
	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job {
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			-- TODO(alvaro): Make the sepatator configurable
			local parts = vim.split(prompt, "  ")
			local args = { "rg" }
			if parts[1] then
				table.insert(args, "-e")
				table.insert(args, parts[1])
			end

			-- TODO(alvaro): We can support multiple globs easily here by adding more of these
			if parts[2] then
				table.insert(args, "-g")
				table.insert(args, parts[2])
			end

			return vim.iter({
				args,
				{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
			}):flatten():totable()
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	}
	pickers.new(opts, {
		prompt_title = "Multi Grep",
		finder = finder,
		previewer = conf.grep_previewer(opts),
		sorter = sorters.empty(),
		debounce = 100,
		max_results = 150,
	}):find()
end

return M
