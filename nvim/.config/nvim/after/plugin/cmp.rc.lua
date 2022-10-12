local setup, cmp = pcall(require, "cmp")
if not setup then
	return
end

-- TODO(alvaro): Make this not 100% required for this to work, give
-- alternate setup
local setup2, lspkind = pcall(require, "lspkind")
if not setup2 then
	return
end

-- TODO(alvaro): Check if `nerd-fonts` is present, and if not default
-- to `codicons` (which requires `vscode-codicons` font setup as a default)
-- And pass it a `preset`

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
		{ name = "nvim_lsp" },
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
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			preset = "default",
			maxwidth = 50,
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
