" Alvaro's Neovim configuration
"
" Load shared vim configuration
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" NOTE(alvaro): For now we don't want to share packages between vim and Neovim
source ~/.vimrc

" Load the package manager (for now we have duplicated config for this
" TODO: Fix the block cursor in insert mode
"           For now I will try it like this, let's see how I like it
" TODO: Set up Language Server (this is the main point of this migration)
" TODO: Set up a more lean status line (this is also needed for main vim)
call plug#begin(stdpath('config') . '/plugged')
" Fuzzy finder
" Plug '~/.fzf'
" Plug 'junegunn/fzf.vim'

" All hail the almighty tpope
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-scriptease'

" TODO(alvaro): Try this out see how it works
Plug 'justinmk/vim-dirvish'

" Lisps
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

Plug 'jpalardy/vim-slime'

" LSP
Plug 'neovim/nvim-lspconfig'
" Plug 'Shougo/deoplete-lsp'

" Completion
" NOTE(alvaro): This project is unmaintained
" Plug 'nvim-lua/completion-nvim'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'

" TODO(alvaro): Look into this
" Plug 'romainl/vim-qf'

" Eye candy
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'j-hui/fidget.nvim'

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'ayu-theme/ayu-vim'

" Other languages
Plug 'sheerun/vim-polyglot'

" Clojure
Plug 'Olical/conjure', { 'tag': 'v4.25.0' }
Plug 'tpope/vim-dispatch'
Plug 'clojure-vim/vim-jack-in'
Plug 'radenling/vim-dispatch-neovim'

" For Lua in neovim development
Plug 'tjdevries/nlua.nvim'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

call plug#end()

" Set up the colorscheme
set termguicolors
" Not bad, looks clean and good but lacks contrast
" colorscheme nord
" Let's try this one first
let ayucolor="dark"  " light/mirage/dark
colorscheme ayu

" TODO(alvaro): Check if this exists, default to vim's dark
" colorscheme base16-default-dark
" let base16colorspace=256
" colorscheme default

" Merge the signcolumn and number column
set signcolumn=number

" Mouse support inside tmux
" TODO: Check this for neovim
" set ttymouse=xterm2
set mouse=a

set scrolloff=10

" Terminal {{{
" Add add settings to these autocommands
augroup alvaro_terminal
    autocmd!
    autocmd TermOpen * setlocal nonumber statusline=%{b:term_title} | startinsert
augroup END

" Mapping to open a quick terminal below
nnoremap <Leader>ts :20sp +term<CR>
nnoremap <Leader>tv :vsp +term<CR>

" NOTE(alvaro): This is duplicated from the <C-H/J/K/L> that we have in .vimrc
" To use `ALT+{h,j,k,l}` to navigate windows from any mode:
tnoremap <A-h> <C-\><C-N><C-W>h
tnoremap <A-j> <C-\><C-N><C-W>j
tnoremap <A-k> <C-\><C-N><C-W>k
tnoremap <A-l> <C-\><C-N><C-W>l
inoremap <A-h> <C-\><C-N><C-W>h
inoremap <A-j> <C-\><C-N><C-W>j
inoremap <A-k> <C-\><C-N><C-W>k
inoremap <A-l> <C-\><C-N><C-W>l
nnoremap <A-h> <C-W>h
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-l> <C-W>l
" }}}

" Nvim necessary config
let g:python3_host_prog = '~/.virtualenv/neovim/bin/python'


" Load the Lua basic configuration
lua require'alvaro'

" Highligh on yank
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}
augroup END

" LSP Settings
" Client configuration (they are configured best using Lua)
lua require'alvaro.lsp'

" Completion {{{
lua require'alvaro.completion'

" Remove the autocomplete option in some buffers
autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
"}}}

" Diagnostic {{{
" NOTE(alvaro): See lua/alvaro/lsp/init.lua for more diagnostic configuration
" directly in Lua

" TODO(alvaro): Set up some highlights for the LspDiagnostics
highlight link LspDiagnosticsVirtualTextError Exception
highlight link LspDiagnosticsVirtualTextWarning Label
highlight link LspDiagnosticsVirtualTextInformation VisualNC
highlight link LspDiagnosticsVirtualTextHint VisualNC
highlight link LspDiagnosticsSignError Exception
highlight link LspDiagnosticsSignWarning Label
highlight link LspDiagnosticsSignInformation VisualNC
highlight link LspDiagnosticsSignHint VisualNC

" Old way (without diagnostic-nvim
" sign define LspDiagnosticsErrorSign text=✘
" sign define LspDiagnosticsWarningSign text=⚠️
" sign define LspDiagnosticsInformationSign text=
" sign define LspDiagnosticsHintSign text=

" TODO(alvaro): Review these
sign define LspDiagnosticsSignError text=E texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=W texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text=I texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text=H texthl=LspDiagnosticsSignHint linehl= numhl=


" TODO(alvaro): Check these options
" let g:diagnostic_virtual_text_prefix = '' " TODO(alvaro): add this
" let g:diagnostic_trimmed_virtual_text = '20'

" Mappings
" nnoremap <silent> <LocalLeader>dn <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" nnoremap <silent> <LocalLeader>dp <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
" nnoremap <silent> <LocalLeader>do <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
" }}}

" Startify {{{
let g:startify_change_to_dir = 0
let g:startify_fortune_use_unicode = 1
let g:startify_relative_path = 1
" }}}

" Allow for project specific settings
" TODO(alvaro): Look into these settings for project specific overrides
" set exrc
" set secure

function! TrimWhitespace()
    let l:saved_pos = getpos('.')
    " NOTE(alvaro): This uses g: to only run this command on the lines that
    " require it, since it could make undo operations VERY slow on larger
    " files
    silent g/\s\+$/s/\s*$//
    " Restore the position of the cursor
    call setpos('.', l:saved_pos)
endfunction

" Trim the whitespace on certain filetypes
" NOTE(alvaro): No rust here since we use rustfmt anyway. Same with go
" TODO(alvaro): Think about vimscript where maybe sometimes we want to keep
" the whitespace
autocmd FileType c,cpp,java,javascript,typescript,python,lua,vim autocmd BufWritePre <buffer> call TrimWhitespace()

" Custom mapping for the GithubOpen
nnoremap <silent> <LocalLeader>g :<C-U>GithubOpen<CR>
" TODO(alvaro): Review this one, we may want to pass the '<,'> range to the
" command call
xnoremap <silent> <LocalLeader>g :GithubOpen<CR>

" Some settings from different languages by vim-polyglot
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1


" Colorscheme / Highlight related stuff
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

command! SynGroup :call SynGroup()
nnoremap <silent> <LocalLeader>sg :<C-U>SynGroup<CR>
