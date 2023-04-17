" Simple Open on Github plugin
" This provides a <plug> mapping for a simple function
"  - GithubOpen that opens github on the current branch and file, and will
"  mark the line as well for easy sharing

if exists('g:github_loaded')
    finish
endif
let g:github_loaded = 1

function! RunGithubOpen(start, end)
    " TODO(alvaro): Get the line ranges
    " TODO(alvaro): Call the GithubOpen function
    echom "The start line is " . a:start
    echom "The end line is " . a:end
endfunction

command! -nargs=0 -range GithubOpen lua require('github').GithubOpen(<line1>, <line2>)
command! -nargs=0 -range GithubOpenCurrent lua require('github').GithubOpen(<line1>, <line2>, true)
" command -nargs=0 -range GithubOpen call RunGithubOpen(<line1>, <line2>)
