local setup, ls = pcall(require, "luasnip")
if not setup then
	return
end

ls.setup({
	-- This tells luasnip to remember the last snippet so you can
	-- jump back to it even if you move outside the selection
	history = true,

	-- TODO(alvaro): Test if this is too distracting
	-- This makes is so that dynamic snippets update as you change
	updateevents = "TextChanged,TextChangedI",

	-- TODO(alvaro): Figure out what these are
	-- Enable autosnippets (if true).
	enable_autosnippets = false,
})

-- Set up mappings

-- <C-K> expand the snippet or jump to the next item
vim.keymap.set({ "i", "s" }, "<C-K>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

-- <C-J> jump backwards
vim.keymap.set({ "i", "s" }, "<C-J>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

-- Save the local config filename for later
local config_filename = vim.fn.expand("%")

-- User command for reloading snippets
function ReloadSnippets()
	vim.cmd("source " .. config_filename)
end

vim.api.nvim_create_user_command("ReloadSnippets", ReloadSnippets, { nargs = 0 })

-- Preload the local snippets that use `SnipMate` syntax (from `snippets/` directory in conf)
require("luasnip.loaders.from_snipmate").lazy_load()

-- Preload the VSCode like snippets from plugins (i.e: rafamadriz/friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()
ls.filetype_extend("python", { "django" })
-- ls.filetype_extend("javascript", {"vue"})

-- Snippets
-- An example of how to add snippets
-- ls.add_snippets("all", {
--     ls.parser.parse_snippet(
--         "lspsyn",
--         "Wow! This ${1:Stuff} really ${2:works. ${3:Well, a bit.}}"
--     ),
-- })

-- An example snippet from TJ's video
local s = ls.s
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("lua", {
	s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
})
