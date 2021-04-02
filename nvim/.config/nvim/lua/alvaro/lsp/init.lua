local lspconfig = require 'lspconfig'
vim.lsp.set_log_level('warn')

-- Function that composes the completion-nvim and diagnostic-nvim on_attach
-- callbacks
local function custom_on_attach(...)
    require'completion'.on_attach(...)
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
    USER = vim.fn.expand("$USER")
    sumneko_root_path = '/Users/' .. USER .. '/github/lua-language-server'
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

lspconfig.pyls.setup{
    on_attach = custom_on_attach,
    settings = {
        pyls = {
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
                black = {
                    enabled = true
                },
                isort = {
                    enabled = true
                },
                flake8 = {
                    enabled = true
                },
                pycodestyle = {
                    enabled = false
                },
                pylint = {
                    enabled = false
                },
                mccabe = {
                    enabled = false
                },
                autopep8 = {
                    enabled = false
                },
                pydocstyle = {
                    enabled = false
                },
                pyflakes = {
                    enabled = false
                },
            }
        }
    }
}

lspconfig.vimls.setup{ on_attach = custom_on_attach }

-- Rust
local function rust_on_attach(...)
    custom_on_attach(...)
    -- Setup for automatic formatting
    vim.api.nvim_command [[ autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000) ]]
end

lspconfig.rust_analyzer.setup{
    on_attach = rust_on_attach,
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
