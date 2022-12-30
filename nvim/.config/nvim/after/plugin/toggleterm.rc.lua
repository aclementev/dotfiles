local status, toggleterm = pcall(require, "toggleterm")
if not status then
	return
end

-- TODO(alvaro): Checkout `ToggleTermSendCurrentLine`,
-- `ToggleTermSendCurrentVisualLines`, `ToggleTermSendCurrentVisualSelection`
toggleterm.setup({
	open_mapping = [[<Leader>to]],
	hide_numbers = true,
	autochdir = true,
	start_in_insert = true,
	insert_mappings = false,
	terminal_mappings = false,
	direction = "float",
	close_on_exit = true,
	auto_scroll = true,
	float_opts = {
		border = "curved",
	},
	winbar = {
		enabled = false,
	},
})
