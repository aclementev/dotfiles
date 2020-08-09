" Alvaro's vim specific configuration
"
set nocompatible

" Plugin (Vim Plug) Settings {{{
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Fuzzy finder
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
" Plug 'mileszs/ack.vim'
" Plug 'ctrlpvim/ctrlp.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
" Plug 'w0rp/ale'

" Language related plugins

" Language Client
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" JS / TS
Plug 'pangloss/vim-javascript',  { 'for': 'javascript' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'posva/vim-vue', { 'for': 'vue' }

" Lisps
Plug 'guns/vim-sexp' "For selecting forms
Plug 'tpope/vim-sexp-mappings-for-regular-people'
" Plug 'junegunn/rainbow_parentheses.vim', { 'for': ['lisp', 'clojure', 'scheme'] }
" Plug 'alvaroclementev/vim-scheme', { 'for': 'scheme', 'on': 'SchemeConnect' }
Plug 'jpalardy/vim-slime'

" LaTeX
Plug 'lervag/vimtex'
Plug 'dpelle/vim-LanguageTool'

" Eye candy
Plug 'machakann/vim-highlightedyank'
Plug 'junegunn/vim-easy-align'

" Colorschemes
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
call plug#end()
" }}}

syntax enable
set background=dark
" Set up the colorscheme
let base16colorspace=256
colorscheme base16-default-dark

" General editing settings {{{
set autoindent

set incsearch
set hlsearch

" Set file encoding to UTF8
set encoding=utf-8

" Statusline settings {{{
set laststatus=2
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#vimtex#enabled=1

" Always show signcolumn so that when an error occurs no visual shift happens
if has('patch-8.1.1564')
    " Merge the signcolumn and number column
    set signcolumn=number
else
    set signcolumn=yes
endif


" NERDTree settings (make NERDTreeCWD the active buffer's directory) {{{
"set autochdir
"let NERDTreeChDirMode=2
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
" }}}

" NOTE: This is duplicated
" FZF Settings {{{
nnoremap <Leader>f :GFiles<CR>    " Fuzzy find git tracked files in current directory
nnoremap <Leader>F :Files<CR>     " Fuzzy find files in current directory
nnoremap <Leader>/ :BLines<CR>    " Fuzzy find lines in current file
nnoremap <Leader>b :Buffers<CR>   " Fuzzy find an open buffer
nnoremap <Leader>r :Rg<CR>        " Fuzzy find text in the working directory
nnoremap <Leader>cc :Commands<CR> " Fuzzy find Vim commands (like Ctrl-Shift-P
nnoremap <Leader>H :Help<CR>     " Fuzzy find files in current directory

" A mapping to show all files, since by default we ignore some of them
if executable('rg')
    command! -bang -nargs=* All
        \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs'}))
endif

let g:fzf_layout={'down': '~20%'}

" }}}

" Coc.vim settings {{{
" TODO: Test these commented settings
" For better display for messages
" set cmdheight=2

" You will have bad experience for diagnostic messages when it's
" default 4000
set updatetime=300
" Don't give |ins-completion-menu| messages
"set shotmess+=c
" Highlight symbol under the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" to match the comments in the JSONC filetype
autocmd FileType json syntax match Comment +\/\/.\+$+

" To trigger the completion with <TAB>
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Make <TAB> the custom key to trigger completion
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
" Make C-Space trigger the suggestions
inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show the documentation
nmap K <SID>show_documentation()<CR>

function! s:show_documentation()
    echom "Showing documentation"
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h ' . expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Show showSignatureHelp
inoremap <C-H> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<CR>

" Remap for rename current word
nmap <Leader>cn <Plug>(coc-rename)

" Remap for format selected region
xmap <Leader>f <Plug>(coc-format-selected)
vmap <Leader>f <Plug>(coc-format-selected)
command! -nargs=0 Format :call CocAction('format')
nmap <LocalLeader>f :Format<CR>

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CocList
" Show all diagnostics
nnoremap <silent><nowait> <Leader>la :<C-u>CocList diagnostics<CR>
" Show all commands
nnoremap <silent><nowait> <Leader>lc :<C-u>CocList commands<CR>
" Show all extensions
nnoremap <silent><nowait> <Leader>le :<C-u>CocList extensions<CR>
" Resume last List
nnoremap <silent><nowait> <Leader>ll :<C-u>CocListResume<CR>
" }}}

" LaTeX
" vimtex
let g:tex_flavor='latex'
" TODO: Move this to a OS specific config
if has('macunix')
    let g:vimtex_view_method='skim'
elseif executable('SumatraPDF')
    let g:vimtex_view_general_viewer='SumatraPDF'
    let g:vimtex_view_general_options='-reuse-instance @pdf'
    let g:vimtex_view_general_options_latexmk='-reuse-instance'
endif
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_fold_enabled=0
let g:tex_comment_nospell=1
" Try this
let g:tex_conceal='abdmgs'
augroup filetype_tex
    autocmd!
    autocmd FileType tex setlocal
        \ conceallevel=1
        \ spell
        \ spelllang=es,en_us
        \ updatetime=4000
        \ colorcolumn=
    autocmd FileType tex nmap <LocalLeader>s <Plug>(vimtex-compile-ss)
    autocmd FileType tex nmap <LocalLeader>cc <Plug>(vimtex-cmd-create)
    autocmd FileType tex xmap <LocalLeader>cc <Plug>(vimtex-cmd-create)
    autocmd FileType tex nmap <LocalLeader>ce <Plug>(vimtex-cmd-create)emph<CR>
    autocmd FileType tex xmap <LocalLeader>ce <Plug>(vimtex-cmd-create)emph<CR>
augroup END

" TODO: Move this to an autocommand to load only when you want it
if isdirectory($HOME . '/languagetool')
    let g:languagetool_jar='$HOME/languagetool/LanguageTool-4.9/languagetool-commandline.jar'
    let g:languagetool_lang='es'
endif

let g:highlightedyank_highlight_duration=750

" vim-easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Rainbow colors
" For some colorscheme, this does not pick
" the correct default
" let g:rainbow#colors = {
" \   'dark': [
" \     ['yellow',  'orange1'     ],
" \     ['green',   'yellow1'     ],
" \     ['cyan',    'greenyellow' ],
" \     ['magenta', 'green1'      ],
" \     ['red',     'springgreen1'],
" \     ['yellow',  'cyan1'       ],
" \     ['green',   'slateblue1'  ],
" \     ['cyan',    'magenta1'    ],
" \     ['magenta', 'purple1'     ]
" \   ],
" \   'light': [
" \     ['darkyellow',  'orangered3'    ],
" \     ['darkgreen',   'orange2'       ],
" \     ['blue',        'yellow3'       ],
" \     ['darkmagenta', 'olivedrab4'    ],
" \     ['red',         'green4'        ],
" \     ['darkyellow',  'paleturquoise3'],
" \     ['darkgreen',   'deepskyblue4'  ],
" \     ['blue',        'darkslateblue' ],
" \     ['darkmagenta', 'darkviolet'    ]
" \   ]
" \ }

" vim-highlightedyank
" Compatibility with versions < 8.0.1394
if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
endif


