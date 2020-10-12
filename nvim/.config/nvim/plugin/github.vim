" Simple Open on Github plugin
" This provides a <plug> mapping for a simple function
"  - GithubOpen that opens github on the current branch and file, and will
"  mark the line as well for easy sharing

" if exists('g:github_loaded')
"     finish
" endif
" let g:github_loaded = 1

command -nargs=0 -range GithubOpen lua require('github').GithubOpen()
