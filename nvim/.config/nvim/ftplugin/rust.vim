" Some simple configuration for Rust development

" TODO(alvaro): Should we add a guard here so that these function
" is only sourced once?

" FIXME(alvaro): Maybe we don't want these mapping to exist only in the rust
"     buffer? these could be handy if we want to run `cargo build` quickly if
"     we are doing something in the terminal itself?
" Some mappings to call Cargo commands for the given project easily from nvim
nnoremap <silent><buffer> <LocalLeader>cb :call rust#CargoBuild()<CR>
nnoremap <silent><buffer> <LocalLeader>ck :call rust#CargoCheck()<CR>
nnoremap <silent><buffer> <LocalLeader>cr :call rust#CargoRun()<CR>


