local setup, cmp = pcall(require, "cmp")
if not setup then
	return
end

compare = require("cmp.config.compare")

-- TODO(alvaro): Make this not 100% required for this to work, give
-- alternate setup
local setup2, lspkind = pcall(require, "lspkind")
if not setup2 then
	return
end

-- TODO(alvaro): Check if `nerd-fonts` is present, and if not default
-- to `codicons` (which requires `vscode-codicons` font setup as a default)
-- And pass it a `preset`

-- Custom `CompletionItemKind` sorting
local kind_mapper = require("cmp.types").lsp.CompletionItemKind
-- TODO(alvaro): Review these, maybe in some languages we want a different sorting?
local kind_score = {
	Variable = 1,
	Class = 2,
	Method = 3,
	Keyword = 4,
	Module = 5,
}

-- Context aware entry filter (see https://www.youtube.com/watch?v=yTk3C3JMKzQ)
local context_entry_filter = function(entry, context)
	local kind = entry:get_kind()

	local line = context.cursor_line
	local col = context.cursor.col
	local char_before_cursor = string.sub(line, col - 1, col - 1)

	if char_before_cursor == "." then
		-- Only Field or Method
		print("Found a ., filtering item with kind=" .. kind)
		return kind == 2 or kind == 5 or kind == 10 or kind == 20
	elseif string.match(line, "^%s*%w*$") then
		-- Text in a new line
		print("Found a newline, filtering item with kind=" .. kind)
		return kind == 3 or kind == 4 or kind == 6 or kind == 9 or kind == 14
	end
	return true
end

-- Limit the size of the PUM
vim.o.pumheight = 20
vim.o.shortmess = vim.o.shortmess .. "c"

-- TODO(alvaro): Add lsp document symbols as well hrsh7th/cmp-nvim-lsp-document-symbol
cmp.setup({
	snippet = {
		expand = function(args)
			-- Use LuaSnip for snippets
			require("luasnip").lsp_expand(args.body)
		end,
	},
	completion = {
		-- Remove this (DO NOT SET TO `true`, just remove) to enable
		-- autocompletion
		autocomplete = false,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		["<C-n>"] = function()
			if cmp.visible() then
				cmp.select_next_item()
			else
				cmp.complete()
			end
		end,
		["<C-p>"] = function()
			if cmp.visible() then
				cmp.select_prev_item()
			else
				cmp.complete()
			end
		end,
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ "i", "s" })
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ "i", "s" })
			else
				fallback()
			end
		end,
	},
	sources = {
		-- The order inside this table represents the order of the results
		{ name = "nvim_lsp", entry_filter = context_entry_filter },
		{ name = "luasnip" },
		{
			name = "buffer",
			option = {
				-- To add other-buffer autocompletion
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
		{ name = "path" },
	},
	-- Better sorting
	sorting = {
		comparators = {
			compare.exact,
			compare.score,
			-- Custom LSP Kind comparator based on LSP's `CompletionItemKind`
			-- (see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItemKind)
			function(entry1, entry2)
				local kind1 = kind_score[kind_mapper[entry1:get_kind()]] or 100
				local kind2 = kind_score[kind_mapper[entry2:get_kind()]] or 100
				if kind1 < kind2 then
					return true
                elseif kind1 > kind2 then
                    return false
				end
			end,
			compare.recently_used,
			compare.length,
		},
	},
	-- Eye Candy
	formatting = {
		-- fields = { "kind", "abbr", "menu" },
		format = lspkind.cmp_format({
			mode = "symbol_text",
			preset = "default",
			maxwidth = 50,
			-- Display the source of the completions
			menu = {
				buffer = "[Buf]",
				nvim_lsp = "[LSP]",
				luasnip = "[Snip]",
				path = "[Path]",
			},
		}),
	},
})

-- Disable for Telescope buffers
cmp.setup.filetype("TelescopePrompt", {
	sources = cmp.config.sources({}),
})

-- TODO(alvaro): Add git commit specific completion from  petertriho/cmp-git
-- and
-- cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--       { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--     }, {
--       { name = 'buffer' },
--     })
--   })
