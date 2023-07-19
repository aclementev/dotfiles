local status, harpoon = pcall(require, "harpoon")
if not status then
	return
end

harpoon.setup()

local opts = { silent = true }

-- Keybinds
vim.keymap.set("n", "<LocalLeader>ha", function()
	require("harpoon.mark").add_file()
end, opts)
vim.keymap.set("n", "<LocalLeader>hh", function()
	require("harpoon.ui").toggle_quick_menu()
end, opts)
vim.keymap.set("n", "<LocalLeader>hn", function()
	require("harpoon.ui").nav_next()
end, opts)
vim.keymap.set("n", "<LocalLeader>hp", function()
	require("harpoon.ui").nav_prev()
end, opts)
vim.keymap.set("n", "<LocalLeader>1", function()
	require("harpoon.ui").nav_file(1)
end, opts)
vim.keymap.set("n", "<LocalLeader>2", function()
	require("harpoon.ui").nav_file(2)
end, opts)
vim.keymap.set("n", "<LocalLeader>3", function()
	require("harpoon.ui").nav_file(3)
end, opts)
vim.keymap.set("n", "<LocalLeader>4", function()
	require("harpoon.ui").nav_file(4)
end, opts)
vim.keymap.set("n", "<LocalLeader>5", function()
	require("harpoon.ui").nav_file(5)
end, opts)
