-- An alias easier to type
function inspect(...)
    print(vim.inspect(...))
end

-- Show the current clients attached the the
function buf_show_clients()
    print(vim.inspect(vim.lsp.buf_get_clients()))
end

-- Find files in directory
function find_in_dir(dir)
    return require('telescope.builtin').find_files({search_dirs={dir}})
end


-- Generates a function that will call find appending a set of hardcoded
-- excludes (useful when not in a git repo with a .gitignore)
function fd_with_excludes(excludes)
    exclude_tbl = {}
    for _, dir in ipairs(excludes) do
        table.insert(exclude_tbl, '--exclude')
        table.insert(exclude_tbl, dir)
    end
    find_options = {
        find_command = vim.list_extend({ 'fd', '--type', 'f' }, exclude_tbl),
        follow = true,
        hidden = true,
    }
    return function()
        return require('telescope.builtin').find_files(find_options)
    end
end

DIRS_TO_IGNORE = {
    '.git',
    'node_modules',
    '.mypy_cache',
    '.pytest_cache',
    '__pycache__',
}
fd_all_with_excludes = fd_with_excludes(DIRS_TO_IGNORE)


-- fidget.nvim
-- progress bar for the LSP
require('fidget').setup{}

-- Telescope
require('telescope').setup{
    defaults = {
        path_display = {
            "truncate",
            -- "shorten",
            -- "smart",
        },
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
-- -- TODO(alvaro): Maybe we want to show_untracked here?
vim.api.nvim_set_keymap('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').git_files({show_untracked = false})<CR>]], { noremap = true, silent = true })
-- TODO(alvaro): Make this mapping default to `find` if `fd` is not installed
vim.api.nvim_set_keymap('n', '<Leader>fa', [[<cmd>lua fd_all_with_excludes()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fA', [[<cmd>lua require('telescope.builtin').find_files({find_command = { 'fd', '--type', 'f' , '--exclude', '.git'}, follow = true, hidden = true, no_ignore = true})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fo', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fC', [[<cmd>lua require('telescope.builtin').commands()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fz', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fc', [[<cmd>lua find_in_dir('~/.config/nvim')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fD', [[<cmd>lua find_in_dir('~/dotfiles')<CR>]], { noremap = true, silent = true })
-- Telescope + LSP
vim.api.nvim_set_keymap('n', '<Leader>fr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fx', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fd', [[<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<CR>]], { noremap = true, silent = true })
-- Telescope + Grep
vim.api.nvim_set_keymap('n', '<Leader>g', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>r', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
