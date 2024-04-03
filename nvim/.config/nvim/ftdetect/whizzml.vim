" TODO(alvaro): Move to use `vim.filetype.add` in `init.lua`
augroup whizzml_ft
    au!
    autocmd BufNewFile,BufRead *.whizzml set ft=lisp
augroup END
