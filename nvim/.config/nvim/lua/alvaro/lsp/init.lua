local lspconfig = require 'lspconfig'
vim.lsp.set_log_level('warn')

-- Setup the common options (completion, diagnostics, keymaps)
local on_attach_general = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    buf_set_keymap('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    buf_set_keymap('n', '<LocalLeader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<LocalLeader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('i', '<C-H>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    -- Others
    -- TODO(alvaro): Do this all in a custom command in lua, now is a bit flickery
    buf_set_keymap('n', 'gs', ':vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>zz', opts)

    -- Diagnostics
    buf_set_keymap('n', '<LocalLeader>dd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<LocalLeader>dn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<LocalLeader>dp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<LocalLeader>do', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Formatting (Conditional to Capabilities)
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap('n', '<LocalLeader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
        -- TODO(alvaro): Is this necessary anymore?
        buf_set_keymap('x', '<LocalLeader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap('n', '<LocalLeader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    end

    -- Autocommand for Highlights
    -- TODO(alvaro): Make this more subtle, for now it's just annoying
    -- if client.resolved_capabilities.document_highlight then
    --     vim.api.nvim_exec([[
    --       hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    --       hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    --       hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    --       augroup lsp_document_highlight
    --         autocmd! * <buffer>
    --         autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    --         autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    --       augroup END
    --     ]], false)
    -- end
end

-- Function that composes the completion-nvim and on_attach
-- callbacks
local function custom_on_attach(...)
    -- For now this does not do anything special
    return on_attach_general(...)
end


-- NOTE(alvaro): In case we want to use this
local function get_python_version()
    local handle = io.popen("python3 --version")
    local result = handle:read() -- Reads only a line, which should be enough
    handle:close()

    if result == nil then
        return nil
    else
        -- Extract the major and minor versions from here
        return string.match(result, "%d.%d")
    end
end

-- Set up for some known servers
-- Lua
-- Inspired from this https://www.chrisatmachine.com/Neovim/28-neovim-lua-development/
local sumneko_root_path
local sumneko_binary
if vim.fn.has('mac') then
    HOME = vim.fn.expand("$HOME")
    sumneko_root_path = HOME .. '/github/lua-language-server'
    sumneko_binary = sumneko_root_path .. '/bin/macOS/lua-language-server'
else
    sumneko_root_path = ''
    sumneko_binary = ''
    print('Unsupported system for sumneko')
end

lspconfig.sumneko_lua.setup{
    -- Lua LSP configuration (inspired by the one in tjdevries/nlua.nvim
    cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
    on_attach=custom_on_attach,
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
    }
}

-- -- TODO(alvaro): This is not appearing as a registered client on python files
-- -- checked with :lua print(vim.inspect(vim.lsp.get_active_clients()))
-- -- and with :lua print(vim.inspect(vim.lsp.buf_get_clients()))
-- lspconfig.pyls_ms.setup{
--     filetypes = { "python" },
--     -- TODO(alvaro): Check the order of these patterns
--     -- TODO(alvaro): There seems to be an issue with the extraPaths, since
--     --     with the setup as it is now (manage.py as root) this works fine
--     root_dir = lspconfig.util.root_pattern('manage.py', '.git', 'setup.py', vim.fn.getcwd()),
--     on_attach=custom_on_attach,
--     init_options = {
--         analysisUpdates = true,
--         asyncStartup = true,
--         displayOptions = {},
--         -- interpreter = {
--         --     properties = {
--         --         InterpreterPath = python_path,
--         --         Version = python_version,
--         --     }
--         -- }
--     },
--     settings = {
--         python = {
--             jediEnabled = false,
--             linting = {
--                 enabled = true
--             },
--             formatting = {
--                 provider = 'yapf'
--             },
--             analysis = {
--                 -- logLevel = 'Trace',
--                 disabled = {},
--                 errors = {},
--                 info = {},
--                 -- cachingLevel = "System", -- To cache the standard library's analysis
--             },
--             autocomplete = {
--                 -- Add here paths for other places to look for imports
--                 extraPaths = {
--                     "./src",
--                     "./src/daimler/mltoolbox"
--                 }
--             }
--         }
--     },
--     log_level = vim.lsp.protocol.MessageType.Log,
--     message_level = vim.lsp.protocol.MessageType.Log
-- }

lspconfig.pylsp.setup{
    on_attach = custom_on_attach,
    settings = {
        pylsp = {
            configurationSources = {'flake8'},
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
    capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )
}

lspconfig.vimls.setup{
    on_attach = custom_on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )
}

-- Rust
local function rust_on_attach(...)
    -- Setup for automatic formatting
    vim.api.nvim_command [[ autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000) ]]
    return custom_on_attach(...)
end

lspconfig.rust_analyzer.setup{
    on_attach = rust_on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )
}

-- Diagnostic setup
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable underline for diagnostics
        underline = false,
        -- Enable virtual_text and add some spacing
        virtual_text = {
            spacing = 2,
        },
        -- Show the Signs in the signcolumn
        signs = true,
        -- Update the diagnostics while on insert mode
        update_in_insert = false,
    }
)
