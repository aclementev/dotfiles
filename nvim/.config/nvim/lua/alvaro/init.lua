-- An alias easier to type
function inspect(...)
    print(vim.inspect(...))
end

-- Show the current clients attached the the
function buf_show_clients()
    print(vim.inspect(vim.lsp.buf_get_clients()))
end

-- Telescope
require('telescope').setup{
    defaults = {
        mappings = {
            -- i = {
            --     ["<c-j>"] = "move_selection_next",
            --     ["<c-k>"] = "move_selection_previous",
            -- }
        }
    }
}
-- This requires an external installation to work properly:
-- https://github.com/nvim-telescope/telescope-fzy-native.nvim
require('telescope').load_extension('fzy_native')

-- Telescope Mappings
vim.api.nvim_set_keymap('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').git_files({show_untracked = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fa', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>r', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fo', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fc', [[<cmd>lua require('telescope.builtin').commands()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fz', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
-- Telescope + LSP
vim.api.nvim_set_keymap('n', '<Leader>fr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fx', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fd', [[<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<CR>]], { noremap = true, silent = true })
