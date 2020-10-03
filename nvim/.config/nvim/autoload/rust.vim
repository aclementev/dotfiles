" Autoload functions for Rust development (see ftplugin/rust.vim for the
" usage)

" TODO(alvaro): Improve error handling with try..catch..endtry
"     and remove other echoerr calls to avoid multiline error messages
" TODO(alvaro): Try this same function in Lua later on
function rust#CargoBuild()
    " Run `cargo build` in an open terminal window
    call utils#term#TermSendCmd("cargo build")
endfunction

function rust#CargoCheck()
    " Run `cargo check` in an open terminal window
    call utils#term#TermSendCmd("cargo check")
endfunction

function rust#CargoRun()
    " Run `cargo run` in an open terminal window
    call utils#term#TermSendCmd("cargo run")
endfunction
