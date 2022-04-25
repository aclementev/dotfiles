local lspconfig = require 'lspconfig'
local lsp_installer = require 'nvim-lsp-installer'
vim.lsp.set_log_level('warn')

-- Prepare the installer
lsp_installer.settings {
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        }
    }
}

-- Setup the common options (completion, diagnostics, keymaps)
local on_attach_general = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings
    local opts = { silent = true, buffer=0 }
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
    if client.resolved_capabilities.document_formatting then
        vim.keymap.set('n', '<LocalLeader>f', vim.lsp.buf.formatting, opts)
        -- TODO(alvaro): Is this necessary anymore?
        vim.keymap.set('x', '<LocalLeader>f', vim.lsp.buf.formatting, opts)
    elseif client.resolved_capabilities.document_range_formatting then
        vim.keymap.set('n', '<LocalLeader>f', vim.lsp.buf.range_formatting, opts)
    end
end

-- Function that composes the completion-nvim and on_attach
-- callbacks
local function custom_on_attach(...)
    -- For now this does not do anything special
    return on_attach_general(...)
end

-- sumneko_lua
local lua_opts = {
    -- Lua LSP configuration (inspired by the one in tjdevries/nlua.nvim
    on_attach = custom_on_attach,
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
}

-- pylsp
local python_opts = {
    on_attach = custom_on_attach,
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
}

-- vimls
local vim_opts = {
    on_attach = custom_on_attach,
    flags = {
        debounce_text_changes = 150,
    },
}


-- vuels
local vue_opts = {
    settings = {
        vetur = {
            ignoreProjectWarning = true,
        }
    },
}

-- Rust
-- Rust is managed by `rust-tools`, so for now we won't use LspInstall
-- local function rust_on_attach(...)
--     -- Setup for automatic formatting
--     vim.api.nvim_command [[ autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000) ]]
--     return custom_on_attach(...)
-- end

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
        on_attach = custom_on_attach,
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
}

-- Wrap with nvim-lsp-installer
lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- Custom server configurations
    if server.name == "sumneko_lua" then
        opts = lua_opts
    elseif server.name == "pylsp" then
        -- NOTE(alvaro): pylsp has extensions, and they can be installed
        -- with the :PylspInstall command that is added to the environment
        -- after installing the pylsp server first
        -- see: https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/pylsp/README.md
        opts = python_opts
    elseif server.name == "vimls" then
        opts = vim_opts
    elseif server.name == "vuels" then
        opts = vue_opts
    end

    -- Update the capabilities as suggested by cmp-nvim-lsp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    opts.capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


    -- Call the server's setup function with the provided configuration
    -- if empty, will use the server's defaults
    server:setup(opts)
end)
