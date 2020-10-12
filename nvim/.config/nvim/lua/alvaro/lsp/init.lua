local nvim_lsp = require 'nvim_lsp'
vim.lsp.set_log_level('info')

-- Function that composes the completion-nvim and diagnostic-nvim on_attach
-- callbacks
local function completion_and_diagnostic_on_attach(...)
    require'completion'.on_attach(...)
    require'diagnostic'.on_attach(...)
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
-- nvim_lsp.sumneko_lua.setup{
--     -- Lua LSP configuration (inspired by the one in tjdevries/nlua.nvim
--     on_attach=completion_and_diagnostic_on_attach,
--     settings = {
--         Lua = {
--             runtime = {
--                 version = "LuaJIT"
--             },
--             diagnostics = {
--                 enable = true,
--                 globals = { "vim" }
--             }
--         }
--     }
-- }

-- Set up using TJ's nlua.nvim
require('nlua.lsp.nvim').setup(nvim_lsp, {
    on_attach = completion_and_diagnostic_on_attach
})

-- TODO(alvaro): This is not appearing as a registered client on python files
-- checked with :lua print(vim.inspect(vim.lsp.get_active_clients()))
-- and with :lua print(vim.inspect(vim.lsp.buf_get_clients()))
nvim_lsp.pyls_ms.setup{
    filetypes = { "python" },
    -- TODO(alvaro): Check the order of these patterns
    -- TODO(alvaro): There seems to be an issue with the extraPaths, since
    --     with the setup as it is now (manage.py as root) this works fine
    root_dir = nvim_lsp.util.root_pattern('manage.py', '.git', 'setup.py', vim.fn.getcwd()),
    on_attach=completion_and_diagnostic_on_attach,
    init_options = {
        analysisUpdates = true,
        asyncStartup = true,
        displayOptions = {},
        -- interpreter = {
        --     properties = {
        --         InterpreterPath = python_path,
        --         Version = python_version,
        --     }
        -- }
    },
    settings = {
        python = {
            jediEnabled = false,
            linting = {
                enabled = true
            },
            formatting = {
                provider = 'yapf'
            },
            analysis = {
                -- logLevel = 'Trace',
                disabled = {},
                errors = {},
                info = {},
                -- cachingLevel = "System", -- To cache the standard library's analysis
            },
            autocomplete = {
                -- Add here paths for other places to look for imports
                extraPaths = {
                    "./src",
                    "./src/daimler/mltoolbox"
                }
            }
        }
    }
}

nvim_lsp.vimls.setup{ on_attach = completion_and_diagnostic_on_attach }

-- Rust
local function rust_on_attach(...)
    completion_and_diagnostic_on_attach(...)
    -- Setup for automatic formatting
    vim.api.nvim_command [[ autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000) ]]
end

nvim_lsp.rust_analyzer.setup{
    on_attach = rust_on_attach,
}
