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
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'

Plug 'jpalardy/vim-slime'

" LSP
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
" Plug 'Shougo/deoplete-lsp'

" Completion
Plug 'nvim-lua/completion-nvim'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Diagnostics
Plug 'nvim-lua/diagnostic-nvim'

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
set signcolumn=number

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

" Nvim necessary config
let g:python3_host_prog = '~/.virtualenv/neovim/bin/python'

" Highligh on yank
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}
augroup END

" LSP Settings
" Client configuration (they are configured best using Lua)
lua require'alvaro.lsp.init'

" Mappings
nnoremap <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gI <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gk <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" TODO(alvaro): Set up file formatting (using yapf or whatever)
"     maybe we can even use the builtin LSP for actions for this
" FIXME(alvaro): Review this setting now that we are using completion-nvim
" autocmd FileType python,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

" TODO(alvaro): Review this
" Completion {{{

set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Every option can be passed through Lua to the dictionary settings for the
" on_attach callback see:
" (https://github.com/nvim-lua/completion-nvim/wiki/per-server-setup-by-lua)

" Disable automatic hover triggering
let g:completion_enable_auto_hover = 0
" let g:completion_enable_auto_signature = 0
" let g:completion_matching_ignore_case = 1
" let g:completion_timer_cycle = 200 " default value is 80

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

inoremap <silent><expr> <Tab> pumvisible() ? "<C-N>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "<C-P>" : "\<S-Tab>"
"}}}

" Diagnostic {{{
let g:diagnostic_enable_virtual_text = 1
let g:space_before_virtual_text = 2

let g:diagnostic_enable_underline = 0
" To avoid showing diagnostics while on insert mode
let g:diagnostic_insert_delay = 0

" Old way (without diagnostic-nvim
" sign define LspDiagnosticsErrorSign text=✘
" sign define LspDiagnosticsWarningSign text=⚠️
" sign define LspDiagnosticsInformationSign text=
" sign define LspDiagnosticsHintSign text=

" TODO(alvaro): Set up some highlights for the LspDiagnostics
highlight link LspDiagnosticsError Exception
highlight link LspDiagnosticsWarning Label
highlight link LspDiagnosticsInformation VisualNC
highlight link LspDiagnosticsHint VisualNC

call sign_define("LspDiagnosticsErrorSign", {"text": "E", "texthl": "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text": "W", "texthl": "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text": "I", "texthl": "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text": "H", "texthl": "LspDiagnosticsHint"})

" TODO(alvaro): Check these options
" let g:diagnostic_virtual_text_prefix = '' " TODO(alvaro): add this
" let g:diagnostic_trimmed_virtual_text = '20'
" }}}

" DEBUG
" call deoplete#enable_logging("DEBUG", "/tmp/deoplete.log")
