local status, lspconfig = pcall(require, "lspconfig")
if not status then
	return
end

-- NOTE: There's also some configuration at `after/plugin/null_ls.rc.lua` for
-- `null-ls` overrides

-- NOTE: The pacakges are installed at `vim.fn.stdpath("data") / "mason"` which
-- points to: `$HOME/.local/share/nvim/mason`
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	log_level = vim.log.levels.INFO, -- Set to DEBUG when debugging issues
})
require("mason-lspconfig").setup()
vim.lsp.set_log_level("warn")

-- Check if value is in table
local function contains(table, value)
	for _, v in pairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

-- Setup lspsaga
local lspsaga_status, lspsaga = pcall(require, "lspsaga")
if lspsaga_status then
	lspsaga.setup({
		lightbulb = {
			enable = false,
		},
	})
end

-- NOTE(alvaro): Since lspsaga v0.2 it requires mappings to use
-- `<cmd>` based rhs for `vim.keymap.set`
-- Setup the common options (completion, diagnostics, keymaps)
local on_attach_general = function(client)
	-- Mappings
	local opts = { silent = true, buffer = 0 }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gI", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, opts)
	vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, opts)
	-- vim.keymap.set('n', '<LocalLeader>rn', vim.lsp.buf.rename, opts)
	-- vim.keymap.set('n', '<LocalLeader>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set("i", "<C-H>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, opts)

	-- LSPSaga related mappings
	if lspsaga_status then
		vim.keymap.set("n", "<LocalLeader>ca", "<cmd>Lspsaga code_action<CR>", opts)
		vim.keymap.set("v", "<LocalLeader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
		-- FIXME(alvaro): update these mappings, although they may just work
		vim.keymap.set("n", "<C-f>", function()
			require("lspsaga.action").smart_scroll_with_saga(4)
		end, opts)
		vim.keymap.set("n", "<C-b>", function()
			require("lspsaga.action").smart_scroll_with_saga(-4)
		end, opts)
		vim.keymap.set("n", "<LocalLeader>rn", "<cmd>Lspsaga rename<CR>", opts)
		vim.keymap.set("n", "<LocalLeader>rN", "<cmd>Lspsaga rename ++project<CR>", opts)
		vim.keymap.set("n", "gp", "<cmd>Lspsaga preview_definition<CR>", opts)
	end

	-- Others
	-- TODO(alvaro): Do this all in a custom command in lua, now is a bit flickery
	vim.keymap.set("n", "gs", ":vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>zz", opts)
	vim.keymap.set("n", "gx", ":sp<CR><cmd>lua vim.lsp.buf.definition()<CR>zz", opts)
end

-- Update the capabilities as suggested by `cmp-nvim-lsp`
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- sumneko_lua
lspconfig.lua_ls.setup({
	on_attach = on_attach_general,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
	capabilities = capabilities,
})

-- pylsp
lspconfig.pylsp.setup({
	on_attach = on_attach_general,
	settings = {
		pylsp = {
			configurationSources = { "flake8" },
			plugins = {
				jedi = {
					extra_paths = {
						"./src",
						"./src/daimler/mltoolbox",
					},
				},
				jedi_completion = {
					enabled = true,
					fuzzy = false,
				},
				jedi_definition = {
					enabled = true,
				},
				black = {
					enabled = true,
				},
				isort = {
					enabled = true,
				},
				flake8 = {
					enabled = true,
				},
				pylsp_mypy = {
					enabled = true,
					live_mode = false,
					dmypy = false,
					report_progress = true,
				},
				-- Disable these plugins explicitly
				pycodestyle = {
					enabled = false,
				},
				pylint = {
					enabled = false,
				},
				mccabe = {
					enabled = false,
				},
				autopep8 = {
					enabled = false,
				},
				pydocstyle = {
					enabled = false,
				},
				pyflakes = {
					enabled = false,
				},
			},
		},
	},
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = capabilities,
})

-- vimls
lspconfig.vimls.setup({
	on_attach = on_attach_general,
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = capabilities,
})

-- TODO(alvaro): vuels (vetur) works for vue 2, for Vue 3 use `volar`
-- vuels
-- lspconfig.vuels.setup {
--     on_attach = on_attach_general,
--     settings = {
--         javascript = {
--             format = {
--                 enable = true,
--             }
--         },
--         vetur = {
--             ignoreProjectWarning = true,
--             format = {
--                 enable = true,
--                 defaultFormatter = {
--                     js = "prettier",
--                     html = "prettier",
--                     css = "prettier",
--                 }
--             }
--         }
--     },
--     capabilities = capabilities,
-- }

lspconfig.volar.setup({
	-- TODO(alvaro): See if this is what we want? This is for "Take Over Mode"
	on_attach = on_attach_general,
	capabilities = capabilities,
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
})

-- Rust
local rust_status, rt = pcall(require, "rust-tools")

if rust_status then
	-- NOTE(alvaro): This uses the `CodeLLDB` VSCode extension for a better
	-- debugging experience, which we manage through `Mason`
	local mason_registry = require("mason-registry")
	local codelldb = mason_registry.get_package("codelldb")
	local extension_path = codelldb:get_install_path() .. "/extension/"
	local codelldb_path = extension_path .. "adapter/codelldb"
	local liblldb_path = extension_path .. "lldb/lib/liblldb"

	local this_os = vim.loop.os_uname().sysname
	if this_os:find("Windows") then
		codelldb_path = extension_path .. "adapter\\codelldb.exe"
		liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
	else
		-- The liblldb extension is '.so' for Linux and '.dylib' for macOS
		liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
	end

	rt.setup({
		tools = {
			executor = require("rust-tools/executors").termopen,
			reload_workspace_from_cargo_toml = true,
			inlay_hints = {
				only_current_line = false,
				show_parameter_hints = true,
				-- TODO(alvaro): Test these
				-- parameter_hints_prefix = "",  -- default is ="<- "
				-- other_hints_prefix = "",  -- default is "=> "
				-- TODO(alvaro): You can also right align
				max_len_align = true,
				max_len_align_padding = 1,
				highlight = "Comment",
			},
			hover_actions = {
				auto_focus = true,
			},
			-- FIXME(alvaro): This is throwing a deprecated error
			-- hover_with_actions = true,
		},
		-- These options are passed to `nvim-lspconfig`
		server = {
			on_attach = on_attach_general,
			flags = {
				debounce_text_changes = 150,
			},
			settings = {
				["rust-analyzer"] = {
					-- enable clippy on save
					checkOnSave = {
						command = "clippy",
					},
				},
			},
			-- Standalone file support
			-- setting it to false may improve startup time
			standalone = false,
		},
		-- debugging stuff
		-- FIXME(alvaro): Unused and untested for now
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
		},
		capabilities = capabilities,
	})
end

-- Go
lspconfig.gopls.setup({
	on_attach = on_attach_general,
	capabilities = capabilities,
})

-- Elixir
lspconfig.elixirls.setup({
	on_attach = on_attach_general,
	capabilities = capabilities,
})

-- Setup notifications
vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
    vim.notify(result.message, lvl, {
        title = "LSP | " .. client.name,
        timeout = 10000,
        keep = function()
            return lvl == "ERROR" or lvl == "WARN"
        end,
    })
end
