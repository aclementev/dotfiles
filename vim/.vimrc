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
nnoremap <Space> <NOP>
let mapleader=" "
" Trying this for now
" TODO: See if this is working for me
nnoremap - <NOP>
let maplocalleader="-"

" Sensible default settings for vim UX {{{
syntax enable
set background=dark
let base16colorspace=256
colorscheme base16-atelier-dune
" Link system clipboard with unnamed buffer (regular copy and paste)
" set clipboard=unnamedplus
" Disable beeping
set vb t_vb=
" Allows for changing buffer without saving (CAUTION!)
set hidden
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
set ignorecase
set smartcase

nnoremap j gj
nnoremap k gk
" }}}

" General editing settings {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set smartcase

set number
" set relativenumber
set wrap
set linebreak
set nolist
set backspace=indent,eol,start
set wildmenu
set lazyredraw
set showmatch

" Where does the new file appear when splitting
set splitright
set splitbelow

set incsearch
set hlsearch

" colorcolumn
set colorcolumn=80

"diffing settings
set diffopt+=vertical
" }}}

" Statusline settings {{{
set encoding=utf-8
set laststatus=2
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#vimtex#enabled=1
let g:airline#extensions#coc#enabled=1

" TODO: Review this customization
" function! AirlineInit()
"     let g:airline_section_z = '%l%c'
" endfunction
" autocmd VimEnter * call AirlineInit()
" }}}


" Manage backup files {{{
set noswapfile
set nobackup
set nowritebackup
" }}}


" Folding {{{
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
" }}}

" Custom MAPPINGS {{{
" Split navigation
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

" Buffer navigation
nnoremap gb :bn<CR>
nnoremap gB :bp<CR>
nnoremap <Leader><Leader> :b#<CR>

" Spell Checking
nnoremap <silent> <F3> :setlocal spell! spelllang=es,en_us<CR>

"TODO: Revise these ones
"Way to open files from current directory
nnoremap <Leader>ew :e <C-R>=fnameescape(expand('%:h')).'/'<cr>
nnoremap <Leader>es :sp <C-R>=fnameescape(expand('%:h')).'/'<cr>
nnoremap <Leader>ev :vsp <C-R>=fnameescape(expand('%:h')).'/'<cr>
nnoremap <Leader>et :tabe <C-R>=fnameescape(expand('%:h')).'/'<cr>
" Other nice editingmappings
nnoremap <Leader>ec :vsplit $MYVIMRC<CR>
nnoremap <Leader>sc :source $MYVIMRC<CR>
nnoremap <Leader>sf :source %<CR>
" Open previous buffer on vsplit
nnoremap <Leader>ep :execute "rightbelow vsplit " . bufname("#")<cr>
" Manage Trailing Whitespaces
nnoremap <silent> <Leader>td mz:%s/\s\+$//<CR>`z
nnoremap <silent> <Leader>tw :match Error /\s\+$/<CR>
nnoremap <silent> <Leader>tW :match<CR>

"(wrapped lines are not ignored)
" set textwidth=80
"Map \v to turn very magic mode in searches and substitutions
nnoremap / /\v
nnoremap ? ?\v
vnoremap / /\v
vnoremap ? ?\v
" Map <Space>h to remove highlight when searching
nnoremap <silent> <Leader>h :nohlsearch<CR>
nnoremap <Leader>* /<C-R><C-A><CR>
nnoremap <Leader># ?<C-R><C-A><CR>
nnoremap <LocalLeader>r :redraw!<CR>

"Capitalize WORD under cursor in INSERT MODE
inoremap <C-U> <ESC>viWUEa
"Capitalize WORD under cursor in NORMAL MODE
nnoremap <Leader>u viWUE
" }}}

" Common typos when exiting or saving {{{
command! W w
command! WQ wq
command! Wq wq
command! Q q
" }}}

" For when we forget to open vim with sudo
" TODO: This only works on *NIX systems
cmap w!! w !sudo tee > /dev/null %

" NERDTree settings (make NERDTreeCWD the active buffer's directory) {{{
"set autochdir
"let NERDTreeChDirMode=2
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
" }}}

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
"set cmdheight=2

" You will have bad experience for diagnostic messages when it's
" default 4000
set updatetime=300
" Don't give |ins-completion-menu| messages
"set shotmess+=c
" Always show signcolumns
"set signcolumns=yes
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
" }}}

" Writing

" Spell checking
" Automatically fix last bad word with the first suggestion
inoremap <C-l> <C-g>u<Esc>[s1z=`]a<C-g>u
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

" vim-highlightedyank
" Compatibility with versions < 8.0.1394
if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
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

" vim-SLIME
let g:slime_no_mappings=1
" Customize the mappings
xmap <LocalLeader><LocalLeader> <Plug>SlimeRegionSend
nmap <LocalLeader><LocalLeader> <Plug>SlimeParagraphSend

let g:slime_target='tmux'
let g:slime_paste_file=tempname()
let g:slime_default_config={"socket_name": "default", "target_pane": "{right-of}"}
let g:slime_dont_ask_default=1

" Vim/Vimscript development
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" vim-vue
let g:vue_pre_processors = 'detect_on_enter'

" FileType specific settings {{{
augroup filetype_make
    " Makefiles need explicit tab characters
    autocmd!
    autocmd FileType make setlocal noexpandtab
augroup END

augroup filetype_javascript
    autocmd!
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

augroup filetype_vue
    autocmd!
    " FIXME: We would expect the vim-vue plugin to use the correct widths
    "        but for now this should do...
    autocmd FileType vue setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END


" }}}

" Vimscript file settings ------------------------ {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
