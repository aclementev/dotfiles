" Alvaro's Neovim configuration
"
" Load shared vim configuration
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" NOTE(alvaro): For now we don't want to share packages between vim and Neovim
source ~/.vimrc

" Load the package manager (for now we have duplicated config for this
" TODO: Fix issue with unresponsive <ESC> key
" TODO: Fix the block cursor in insert mode
" TODO: Set up highlight on yank
" TODO: Check the pythonx and other extensions (? see the vim-to-nvim guide)
" TODO: Set up Language Server (this is the main point of this migration)
" TODO: Set up a more lean status line (this is also needed for main vim)
call plug#begin(stdpath('config') . 'init.vim')
" Fuzzy finder
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'

Plug 'jpalardy/vim-slime'

" Eye candy
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Colorschemes
Plug 'chriskempson/base16-vim'
call plug#end()

" Set up the colorscheme
let base16colorspace=256
colorscheme base16-default-dark

" Merge the signcolumn and number column
" NOTE(alvaro): Not merged yet into neovim
" set signcolumn=number

" Mouse support inside tmux
" TODO: Check this for neovim
" set ttymouse=xterm2
set mouse=a


" NOTE: This is duplicated
" FZF Settings {{{
" Fuzzy find git tracked files in current directory
nnoremap <Leader>f :GFiles<CR>
" Fuzzy find files in current directory
nnoremap <Leader>F :Files<CR>
" Fuzzy find lines in current file
nnoremap <Leader>/ :BLines<CR>
" Fuzzy find an open buffer
nnoremap <Leader>b :Buffers<CR>
" Fuzzy find text in the working directory
nnoremap <Leader>r :Rg<CR>
" Fuzzy find Vim commands (like Ctrl-Shift-P
nnoremap <Leader>cc :Commands<CR>
" Fuzzy find files in current directory
nnoremap <Leader>H :Help<CR>

" A mapping to show all files, since by default we ignore some of them
if executable('rg')
    command! -bang -nargs=* All
        \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs'}))
endif

let g:fzf_layout={'down': '~20%'}

" }}}
