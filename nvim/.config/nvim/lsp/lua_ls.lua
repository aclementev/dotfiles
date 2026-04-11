return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },

            diagnostics = {
                globals = { "vim" },
            },

            workspace = {
                library = {
                    vim.fn.stdpath("config"),
                    vim.fn.stdpath("data") .. "/lazy",
                    unpack(vim.api.nvim_get_runtime_file("", true)),
                },
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
