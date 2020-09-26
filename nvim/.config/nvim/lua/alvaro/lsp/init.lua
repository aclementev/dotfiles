local nvim_lsp = require 'nvim_lsp'
vim.lsp.set_log_level('trace')

-- Function that composes the completion-nvim and diagnostic-nvim on_attach
-- callbacks
local function completion_and_diagnostic_on_attach(...)
    require'completion'.on_attach(...)
    require'diagnostic'.on_attach(...)
end

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

-- Try to guess the current virtual environment for the pyls-ms configuration
local python_path = vim.api.nvim_call_function('exepath', {'python3'})
local python_version = get_python_version()

-- TODO(alvaro): This should only run on python related files
if python_version == nil then
    print('no python3 found on $PATH')
else
    print(string.format('found a python at "%s" (v%s)', python_path, python_version))
end

nvim_lsp.pyls_ms.setup{
    on_attach=completion_and_diagnostic_on_attach,
    init_options = {
        interpreter = {
            properties = {
                InterpreterPath = python_path,
                Version = python_version,
            }
        }
    },
    -- root_dir = ?,
    settings = {
        python = {
            formatting = {
                provider = 'yapf'
            },
            jediEnabled = false,
            analysis = {
                -- logLevel = 'Trace',
                disabled = {},
                errors = {},
                info = {},
            }
        }
    }
}

-- nvim_lsp.vimls.setup{}
-- Trying to debug
