-- TreeSitter configuration
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        -- Enable this if we see that this is too broken for now
        additional_vim_regex_highlighting = false,
    },
    indent = {
        -- NOTE: This is still experimental
        enable = true,
    }
}
