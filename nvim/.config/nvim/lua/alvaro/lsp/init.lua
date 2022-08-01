local lspconfig = require 'lspconfig'
-- NOTE: The pacakges are installed at `vim.fn.stdpath("data") / "mason"` which
-- points to: `$HOME/.local/share/nvim/mason`
require('mason').setup {
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        }
    },
    log_level = vim.log.levels.INFO, -- Set to DEBUG when debugging issues
}
require('mason-lspconfig').setup()
vim.lsp.set_log_level('warn')

-- TODO(alvaro): Checkout lspsaga for some nicer UI for `K` and hover docs
-- and other things

-- Setup the common options (completion, diagnostics, keymaps)
local on_attach_general = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings
    local opts = { silent = true, buffer = 0 }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'g0', vim.lsp.buf.document_symbol, opts)
    vim.keymap.set('n', 'gW', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<LocalLeader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<LocalLeader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('i', '<C-H>', vim.lsp.buf.signature_help, opts)

    -- Others
    -- TODO(alvaro): Do this all in a custom command in lua, now is a bit flickery
    vim.keymap.set('n', 'gs', ':vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>zz', opts)

    -- Formatting (Conditional to Capabilities)
    if client.server_capabilities.documentFormattingProvider then
        print("setting up formatting bindings")
        vim.keymap.set('n', '<LocalLeader>f', function()
            vim.lsp.buf.format{ async = true }
        end, opts)
        -- TODO(alvaro): Is this necessary anymore?
        vim.keymap.set('x', '<LocalLeader>f', function()
            vim.lsp.buf.format{ async = true }
        end, opts)
    elseif client.server_capabilities.documentRangeFormattingProvider then
        vim.keymap.set('n', '<LocalLeader>f', vim.lsp.buf.range_formatting, opts)
    else
        print("No formatting capabilities reported")
    end
end

-- Update the capabilities as suggested by `cmp-nvim-lsp`
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- sumneko_lua
lspconfig.sumneko_lua.setup {
    -- Lua LSP configuration (inspired by the one in tjdevries/nlua.nvim
    on_attach = on_attach_general,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                -- TODO(alvaro): Review this
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/lsp")] = true,
                }
            },
            telemetry = {
                enable = false
            },
        }
    },
    capabilities=capabilities,
}

-- pylsp
lspconfig.pylsp.setup {
    on_attach = on_attach_general,
    settings = {
        pylsp = {
            configurationSources = { 'flake8' },
            plugins = {
                jedi = {
                    extra_paths = {
                        "./src",
                        "./src/daimler/mltoolbox"
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
                -- Temporarily disable these globally (should be per-project)
                -- TODO(alvaro): Make this work so we can remove the awful
                -- `pylsp-mypy.cfg` file
                pyls_mypy = {
                    enabled = false,
                    live_mode = true,
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
            }
        }
    },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities=capabilities,
}

-- vimls
lspconfig.vimls.setup {
    on_attach = on_attach_general,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities=capabilities,
}


-- TODO(alvaro): vuels (vetur) works for vue 2, for Vue 3 use `volar`
-- vuels
lspconfig.vuels.setup {
    on_attach = on_attach_general,
    settings = {
        javascript = {
            format = {
                enable = true,
            }
        },
        vetur = {
            ignoreProjectWarning = true,
            format = {
                enable = true,
                defaultFormatter = {
                    js = "prettier",
                    html = "prettier",
                    css = "prettier",
                }
            }
        }
    },
    capabilities=capabilities,
}

-- lspconfig.volar.setup {
    -- TODO(alvaro): See if this is what we want? This is for "Take Over Mode"
    -- filetypes = {"typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json"}
    -- on_attach = on_attach_general,
    -- capabilities=capabilities,
-- }

-- Rust
require('rust-tools').setup {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        -- test this out
        -- inlay_hints = {
        --     show_parameter_hints = false,
        --     parameter_hints_prefix = "",
        --     other_hints_prefix = "",
        -- }
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
                }
            }
        }
    },
    capabilities=capabilities,
}
