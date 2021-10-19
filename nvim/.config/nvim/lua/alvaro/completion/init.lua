-- Setup for completion
-- For now we will use this with `hrsh7th/nvim-cmp`

local cmp = require('cmp')

-- Limit the size of the PUM
vim.o.pumheight = 20
vim.o.shortmess = vim.o.shortmess .. 'c'

cmp.setup {
    snippet = {
        expand = function() end  -- Do nothing for now
    },
    completion = {},
    mapping = {
        ['<C-n>'] = function()
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end,
        ['<C-p>'] = function()
            if cmp.visible() then
                cmp.select_prev_item()
            else
                cmp.complete()
            end
        end,
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        -- FIXME(alvaro): Make this work
        -- ['<CR>'] = cmp.mapping.confirm({
        --     select = true,
        -- }),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ "i", "s" })
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ "i", "s" })
            else
                fallback()
            end
        end,
    },
    sources = {
        -- The order inside this table represents the order of the results
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
    formatting = {
        -- TODO(alvaro): Make the icons pretty
        format = require('lspkind').cmp_format({
            with_text = false,
            preset = 'codicons',
            maxwidth = 50
        })
    },
}

-- NOTE(alvaro): This has to marked as a capability inside the LSP configuration
-- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
--     capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- }
