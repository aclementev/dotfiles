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
Plug 'nvim-lua/completion-nvim'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" TODO(alvaro): Look into this
" Plug 'romainl/vim-qf'

" Eye candy
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'ayu-theme/ayu-vim'

" Other languages
Plug 'sheerun/vim-polyglot'

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

" FIXME(alvaro): Superseeded by Telescope in init.lua
" FZF Settings {{{

" Add a mapping for closing the terminal window for FZF
" autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

" function! RipgrepFzf(query, fullscreen)
"   let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
"   let initial_command = printf(command_fmt, shellescape(a:query))
"   let reload_command = printf(command_fmt, '{q}')
"   let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
"   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
" endfunction
" command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" " Fuzzy find git tracked files in current directory
" nnoremap <Leader>ff :GFiles<CR>
" " Fuzzy find files in current directory (git ls-files)
" nnoremap <Leader>fa :Files<CR>
" " Fuzzy find git tracked and untracked files in current directory (git status)
" nnoremap <Leader>fs :GFiles?<CR>
" " Fuzzy find lines in current file
" nnoremap <Leader>f/ :BLines<CR>
" " Fuzzy find an open buffer
" nnoremap <Leader>fb :Buffers<CR>
" " Fuzzy find Vim commands (like Ctrl-Shift-P)
" nnoremap <Leader>fc :Commands<CR>
" " Fuzzy find files in current directory
" nnoremap <Leader>fh :Help<CR>
" " Fuzzy find files in oldfiles
" nnoremap <Leader>fo :History<CR>

" " Fuzzy find text in the working directory using RipgrepFzf function
" nnoremap <Leader>r :RG<CR>
" " Fuzzy find text in the working directory using regular FZF.vim
" nnoremap <Leader>fr :Rg<CR>
" " Fuzzy find words under the cursor
" nnoremap <Leader>g :RG <C-R><C-W><CR>

" " A mapping to show all files, since by default we ignore some of them
" if executable('rg')
"     command! -bang -nargs=* All
"         \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs'}))
" endif

" " Fuzzy find all files without ingoring any
" nnoremap <Leader>fa :All<CR>

" let g:fzf_layout={'down': '~25%'}

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
lua require'alvaro.lsp.init'

" Mappings
" nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> gI <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gk <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <silent> <LocalLeader>f <cmd>lua vim.lsp.buf.formatting()<CR>
" xnoremap <silent> <LocalLeader>f <cmd>lua vim.lsp.buf.range_formatting()<CR>

" inoremap <silent> <C-H> <cmd>lua vim.lsp.buf.signature_help()<CR>

" TODO(alvaro): Set up file formatting (using yapf or whatever)
"     maybe we can even use the builtin LSP for actions for this
" FIXME(alvaro): Review this setting now that we are using completion-nvim
" autocmd FileType python,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

" TODO(alvaro): Review this
" Completion {{{

set completeopt=menuone,noinsert,noselect
set shortmess+=c
" Limit the number of completion options to give
set pumheight=20

" Every option can be passed through Lua to the dictionary settings for the
" on_attach callback see:
" (https://github.com/nvim-lua/completion-nvim/wiki/per-server-setup-by-lua)

" Disable automatic hover triggering
let g:completion_enable_auto_hover = 0
" let g:completion_enable_auto_signature = 0
" let g:completion_matching_ignore_case = 1
let g:completion_timer_cycle = 200 " default value is 80
" Remove the sorting, asume they are given sorted by the completion source
let g:completion_sorting = "none"

let g:completion_matching_strategy_list = ['exact', 'substring']

" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

inoremap <silent><expr> <Tab> pumvisible() ? "<C-N>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "<C-P>" : "\<S-Tab>"
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
