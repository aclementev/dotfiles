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
call plug#begin(stdpath('config') . 'init.vim')
" Fuzzy finder
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'

Plug 'jpalardy/vim-slime'

" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" LSP
Plug 'neovim/nvim-lsp'
Plug 'Shougo/deoplete-lsp'


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

" Nvim necessary config
let g:python3_host_prog = '/Users/alvaro/.virtualenv/neovim/bin/python'

" Highligh on yank
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}
augroup END

" LSP Settings
" Client configuration (they are configured best using Lua)
:lua << END
    local nvim_lsp = require 'nvim_lsp'
    vim.lsp.set_log_level(0)

    -- Set up for some known servers
    python_path = vim.api.nvim_call_function('exepath', {'python3'})
    -- print('Setting the python interpreter path to: ' .. (python_path or 'EMPTY'))
    nvim_lsp.pyls_ms.setup{
        init_options = {
            interpreter = {
                properties = {
                    InterpreterPath = python_path,
                    Version = "3.7" -- TODO: Make this dynamic
                }
            }
        },
        settings = {
            python = {
                -- pythonPath = python_path,
                formatting = {
                    provider = 'yapf'
                },
                jediEnabled = false,
                analysis = {
                    logLevel = 'Trace'
                }
            }
        }
    }

    -- nvim_lsp.vimls.setup{}
    -- Trying to debug
END

sign define LspDiagnosticsErrorSign text=✘
sign define LspDiagnosticsWarningSign text=⚠️
" sign define LspDiagnosticsInformationSign text=
" sign define LspDiagnosticsHintSign text=

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

" TODO: Set up file formatting (using yapf or whatever)
autocmd FileType python,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

" Completion {{{
let g:deoplete#enable_at_startup = 1
set completeopt-=preview

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()
"}}}

" DEBUG
" call deoplete#enable_logging("DEBUG", "/tmp/deoplete.log")
