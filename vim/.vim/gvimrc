"GVIM specific config
if has('gui_running')
    set guifont=Hack:h10
    colorscheme base16-ocean
    "start maximized
    au GUIEnter * simalt ~x
    let $MYVIMRC=$HOME.'\.vim\.vimrc'
    "Ignore Files/Directories for Fuzzy Finders
    set wildignore+=*/AppData/*
    set vb t_vb=

    set guioptions-=m "remove top menu bar
    set guioptions-=T "remove toolbar
    set guioptions-=r "remove right scroll bar
    set guioptions-=L "remove left scroll bar
    
    "If airline is installed, it already shows the mode
    set noshowmode

    "Remove F1 help mapping
    nnoremap <F1> <NOP>
    inoremap <F1> <NOP>
endif

"if has('autocmd')
"          autocmd GUIEnter * set visualbell t_vb=
"endif

