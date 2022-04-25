-- Neovim builtin diagnostic setup
vim.diagnostic.config {
    underline = false,
    signs = true,
    virtual_text = true,
    float = {
        -- TODO(alvaro): Test this
        -- show_header = true,
    },
    update_in_insert = false,
    severity_sort = true,
}

-- FIXME(alvaro): This is probably not necessary anymore
-- Diagnostic setup
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--         -- Disable underline for diagnostics
--         underline = false,
--         -- Enable virtual_text and add some spacing
--         virtual_text = {
--             spacing = 2,
--         },
--         -- Show the Signs in the signcolumn
--         signs = true,
--         -- Update the diagnostics while on insert mode
--         update_in_insert = false,
--     }
-- )

-- Setup the Mappings
local map_opts = { noremap=true, silent=true }
local goto_opts = { wrap = true, float = true }

vim.keymap.set("n", "<LocalLeader>dd", function()
    vim.diagnostic.open_float()
end, map_opts)
vim.keymap.set("n", "<LocalLeader>dn", function()
    vim.diagnostic.goto_next(goto_opts)
end, map_opts)
vim.keymap.set("n", "<LocalLeader>dp", function()
    vim.diagnostic.goto_prev(goto_opts)
end, map_opts)
vim.keymap.set("n", "<LocalLeader>do", function()
    vim.diagnostic.setloclist()
end, map_opts)
