print("Hello from init.lua")

-- FIXME(alvaro): This should be handled automatically (?)
vim.cmd [[ source "~/.vimrc" ]]

-- General Options
vim.opt.signcolumn = "yes:1" -- Merge the signcolumn and number column
vim.opt.mouse = "a" -- Setup the mouse
vim.opt.scrolloff = 10 -- Space when scrolling UP and DOWN

-- FIXME(alvaro): This is not the location where we want them to be anymore
vim.g.python3_host_prog = '~/.virtualenv/neovim/bin/python'

-- Fix the colorscheme so that the SignColumn does not have a different
-- background
-- Make sure it is applied everytime we change the colorscheme
-- NOTE: This must happen before sourcing the colorscheme, or else it's not
-- applied on first execution
local transparent_augroup = vim.api.nvim_create_augroup("transparent_signs", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    group = transparent_augroup,
    command = "highlight SignColumn guibg=NONE"
})

-- Set the colorscheme
-- XXX(alvaro): Enable back this
-- require('alvaro.colorscheme')

-- FIXME(alvaro): Review if we are using these, since we are now using `term-edit`
-- Terminal Settings
local terminal_augroup = vim.api.nvim_create_augroup("alvaro_terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    group = terminal_augroup,
    command = "setlocal nonumber statusline=%{b:term_title} | startinsert"
})
vim.keymap.set("n", "<Leader>ts", ":20sp +term<CR>")
vim.keymap.set("n", "<Leader>tv", ":vsp +term<CR>")

-- Set the highlight on yank
local highlight_augroup = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = highlight_augroup,
    callback = function(e)
        vim.highlight.on_yank {higroup="IncSearch", timeout=300}
    end
})


-- Print the syntax group of the element under the cursor
function syn_group(opts)
    local pos = vim.fn.getpos('.')
    local line = pos[2]
    local col = pos[3]
    local syn_id = vim.fn.synID(line, col, 1)
    print(vim.fn.synIDattr(syn_id, "name"), "->", synIDattr(vim.fn.synIDtrans(syn_id), "name"))
end
vim.api.nvim_create_user_command("SynGroup", syn_group, { desc = "Print the syntax group of the element under the cursor"})
vim.keymap.set("n", "<LocalLeader>sg", ":<C-U>SynGroup<CR>", { silent = true })


-- XXX(alvaro): Enable back these
-- Load the basic configuration
-- require('before')
-- require('alvaro')
-- require('alvaro.lsp')
-- require('alvaro.diagnostic')

-- FIXME(alvaro): Move this to its own file
-- Vim Test
vim.g["test#strategy"] = "neovim" -- TODO(alvaro): Review this
vim.keymap.set("n", "<Leader>tt", ":TestNearest<CR>", { silent = true })
vim.keymap.set("n", "<Leader>tf", ":TestFile<CR>", { silent = true })
vim.keymap.set("n", "<Leader>ta", ":TestSuite<CR>", { silent = true })
vim.keymap.set("n", "<Leader>tl", ":TestLast<CR>", { silent = true })
vim.keymap.set("n", "<Leader>tg", ":TestVisit<CR>", { silent = true })


-- FIXME(alvaro): Move this to utilities or formatting file
function trim_whitespace()
    -- Store the current position of the cursor
    local pos = vim.fn.getpos('.')
    -- Trim the trailing whitespace from the whole document
    -- NOTE: This may move the cursor
    vim.cmd [[ silent g/\s\+$/s/\s*$// ]]
    -- Restore the position before the trimming
    vim.fn.setpos('.', pos)
end

-- TODO(alvaro): Maybe enable this back?
-- Setup automatic space trimming on some files
-- autocmd FileType c,cpp,java,javascript,typescript,python,lua,vim autocmd BufWritePre <buffer> call TrimWhitespace()


-- Complex custom mappings
vim.keymap.set("n", "<LocalLeader>gg", ":<C-U>GithubOpen<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>gG", ":<C-U>GithubOpenCurrent<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>gg", ":GithubOpen<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>gG", ":GithubOpenCurrent<CR>", { silent = true })

vim.api.nvim_create_user_command("JSONFormat", ":%! jq .", { desc = "Prettify JSON using jq"})
vim.api.nvim_create_user_command("JSONCompact", ":%! jq -c .", { desc = "Compact JSON using jq"})


-- TODO(alvaro): Configure conjure again
-- " Conjure configuration
-- "clojure", "fennel", "janet", "hy", "julia", "racket",
-- "scheme", "lua", "lisp", "python", "rust", "sql"
-- let g:conjure#filetypes = ["clojure", "fennel", "janet", "hy", "racket", "scheme", "lisp"]
-- let g:conjure#filetype#julia = v:false
-- let g:conjure#filetype#lua = v:false
-- let g:conjure#filetype#python = v:false
-- let g:conjure#filetype#rust = v:false
-- let g:conjure#filetype#sql = v:false

-- OTHER OPTIONS
-- Disable NetRW for Nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.startify_change_to_dir = 0
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_relative_path = 1
