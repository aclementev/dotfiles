nnoremap <Space> <NOP>
let mapleader=" "
" Trying this for now
nnoremap - <NOP>
let maplocalleader="-"

" Sensible default settings for vim UX {{{
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

" colorcolumn
set colorcolumn=80

"diffing settings
set diffopt+=vertical
" }}}

" Statusline settings {{{
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

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

" Yanking to System Clipboard
vnoremap <Leader>y "*y
nnoremap Y y$
" Split navigation
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

" Buffer navigation
nnoremap gb :bn<CR>
nnoremap gB :bp<CR>
nnoremap <LocalLeader>b :b#<CR>

" Window resizing
" TODO(alvaro): Find a way to make the directions more intuitive by
" looking if we are at an edge
nnoremap <silent> <Right> :vertical resize +2<CR>
nnoremap <silent> <Left> :vertical resize -2<CR>
nnoremap <silent> <Up> :resize +2<CR>
nnoremap <silent> <Down> :resize -2<CR>

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
nnoremap <Leader>ee :vsplit ~/.vimrc<CR>
nnoremap <Leader>ep :vsplit ~/.vim/vim-specific.vim<CR>
nnoremap <Leader>sf :source %<CR>
" Open previous buffer on vsplit
nnoremap <Leader>ep :execute "rightbelow vsplit " . bufname("#")<cr>
" Manage Trailing Whitespaces
nnoremap <silent> <Leader>td mz:%s/\s\+$//<CR>`z
nnoremap <silent> <Leader>tw :match Error /\s\+$/<CR>
nnoremap <silent> <Leader>tW :match<CR>
nnoremap <LocalLeader>ee :echo expand('%')<CR>

""Map \v to turn very magic mode in searches and substitutions
"nnoremap / /\v
"nnoremap ? ?\v
"vnoremap / /\v
"vnoremap ? ?\v

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

" Quickfix movements
nnoremap <silent> <LocalLeader>cn :cnext<CR>
nnoremap <silent> <LocalLeader>cp :cprevious<CR>
nnoremap <silent> <LocalLeader>co :copen<CR>
nnoremap <silent> <LocalLeader>cc :cclose<CR>

" Location List movements
nnoremap <silent> <LocalLeader>ln :lnext<CR>
nnoremap <silent> <LocalLeader>lp :lprevious<CR>
nnoremap <silent> <LocalLeader>lo :lopen<CR>
nnoremap <silent> <LocalLeader>lc :lclose<CR>

" Other mappings
nnoremap <Leader>cw :%s/\<<C-R><C-W>\>/
" }}}
"

" Integrated terminal mappings
" Make the terminal usable
" Regain control of escape key
" TODO(alvaro): configure the expected insert mode terminal
" bindings
" set termwinkey=<C-]>
" tnoremap <C-W> <C-]><C-W>
tnoremap <ESC> <C-\><C-N>
" Simulate i_CTRL-R in terminal mode
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'


" For when we forget to open vim with sudo
" TODO: This only works on *NIX systems
cmap w!! w !sudo tee > /dev/null %

" Writing
" Automatically fix last bad word with the first suggestion
inoremap <C-l> <C-g>u<Esc>[s1z=`]a<C-g>u

" vim-SLIME
let g:slime_no_mappings=1
" Customize the mappings
xmap <LocalLeader><LocalLeader> <Plug>SlimeRegionSend
nmap <LocalLeader><LocalLeader> <Plug>SlimeParagraphSend

let g:slime_target='tmux'
let g:slime_paste_file=tempname()
let g:slime_default_config={"socket_name": "default", "target_pane": "{right-of}"}
let g:slime_dont_ask_default=1
" Use IPython's %cpaste magic function to send snippets to IPython easily
let g:slime_python_ipython=1

" Vim/Vimscript development
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

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

if !has('nvim')
    " load the vim specific settings
    execute 'source ' . expand('<sfile>:p:h') . '/.vim/vim-specific.vim'
endif
