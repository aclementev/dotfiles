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
-- LUA
nvim_lsp.sumneko_lua.setup{
    -- Lua LSP configuration (inspired by the one in tjdevries/nlua.nvim
    on_attach=completion_and_diagnostic_on_attach,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT"
            },
            diagnostics = {
                enable = true,
                globals = { "vim" }
            }
        }
    }

}

-- TODO(alvaro): This is not appearing as a registered client on python files
-- checked with :lua print(vim.inspect(vim.lsp.get_active_clients()))
-- and with :lua print(vim.inspect(vim.lsp.buf_get_clients()))
nvim_lsp.pyls_ms.setup{
    filetypes = { "python" },
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
                    "./src"
                }
            }
        }
    }
}

nvim_lsp.vimls.setup{ on_attach = completion_and_diagnostic_on_attach }
