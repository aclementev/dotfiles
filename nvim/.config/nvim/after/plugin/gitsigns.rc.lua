local status, gitsigns = pcall(require, "gitsigns")
if not status then
	return
end

gitsigns.setup({
	numhl = true,
	on_attach = function(bufnr)
		local function map(mode, l, r, opts)
			opts = opts or { silent = true }
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gitsigns.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gitsigns.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map("n", "<LocalLeader>gs", gitsigns.stage_hunk)
		map("n", "<LocalLeader>gr", gitsigns.reset_hunk)
		map("v", "<LocalLeader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("v", "<LocalLeader>gr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("n", "<LocalLeader>gS", gitsigns.stage_buffer)
		map("n", "<LocalLeader>gu", gitsigns.undo_stage_hunk)
		map("n", "<LocalLeader>gR", gitsigns.reset_buffer)
		map("n", "<LocalLeader>gP", gitsigns.preview_hunk)
		map("n", "<LocalLeader>gb", function()
			gitsigns.blame_line({ full = true })
		end)
		map("n", "<LocalLeader>tb", gitsigns.toggle_current_line_blame)
		map("n", "<LocalLeader>gd", gitsigns.diffthis)
		map("n", "<LocalLeader>gD", function()
			gitsigns.diffthis("~")
		end)
		map("n", "<LocalLeader>td", gitsigns.toggle_deleted)

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
