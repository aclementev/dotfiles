local setup, ls = pcall(require, "luasnip")
if not setup then
    return
end

ls.setup({
    -- This tells luasnip to remember the last snippet so you can
    -- jump back to it even if you move outside the selection
    history = false,
    -- TODO(alvaro): Test if this is too distracting
    -- This makes is so that dynamic snippets update as you change
    updateevents = "TextChanged,TextChangedI",
    -- TODO(alvaro): Figure out what these are
    -- Enable autosnippets (if true).
    enable_autosnippets = false,
})

-- Set up mappings

-- <C-J> expand the snippet or jump to the next item
vim.keymap.set({ "i", "s" }, "<C-J>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

-- <C-K> jump backwards
vim.keymap.set({ "i", "s" }, "<C-K>", function()
    if ls.jumpable( -1) then
        ls.jump( -1)
    end
end, { silent = true })

-- Preload the local snippets that use `SnipMate` syntax (from `snippets/` directory in conf)
require("luasnip.loaders.from_snipmate").lazy_load()

-- Preload the VSCode like snippets from plugins (i.e: rafamadriz/friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()
ls.filetype_extend("python", { "django" })
-- ls.filetype_extend("javascript", {"vue"})
