local status, null_ls = pcall(require, "null-ls")

if not status then
    return
end

-- FIXME(alvaro): We need to make sure that the LSP bindings are applied
-- here as well... maybe we should migrate this to the main LSP config
null_ls.setup({
    sources = {
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- TODO(alvaro): Make this more granular so that it only affects Vue
        -- Vue + JS + Typescript
        null_ls.builtins.diagnostics.eslint_d,
        -- TODO(alvaro): Depending on the project we may want one or the other...
        -- maybe with `.editorconfig` will allow us to fix this automatically?
        null_ls.builtins.formatting.eslint_d,
        -- null_ls.builtins.formatting.prettier,
    },
})
