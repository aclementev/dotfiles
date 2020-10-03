" Terminal related utility functions

function! utils#term#TermSendCmd(cmd)
    " This sends a command to the terminal, but does not care about what it
    " sends back
    let l:terminals = utils#term#GetTermBufnr()
    if len(l:terminals) > 1
        echoerr "found multiple terminals opened"
        return
    elseif len(l:terminals) == 0
        " TODO(alvaro): Open a new terminal window
        echoerr "failed to find a terminal buffer opened"
        return
    endif
    let l:term_bufnr = l:terminals[0]
    if l:term_bufnr < 1
        " This appears to happen as well if there's more than one
        echoerr "invalid terminal id"
        return
    endif
    let l:term_chan_id = nvim_buf_get_option(l:term_bufnr, "channel")
    if l:term_chan_id == -1
        echoerr "failed to retrieve the terminal's channel"
        return
    endif

    " Terminal escape sequence to clear the current line
    " NOTE(alvaro): We add a `\r` at the end so that we write on top of the
    " old text
    " TODO(alvaro): Figure out how to send this escape sequence so that it
    "     clears out the text already in the line (change ' to " later)
    " let l:clear_line_escape = '\033[2K\r'
    " let l:command_str = l:clear_line_escape . a:cmd . '\n'

    let l:command_str = a:cmd . "\n"
    let l:nbytes= chansend(l:term_chan_id, l:command_str)
endfunction

function! utils#term#GetTermBufnr()
    let l:terminals = []
    " We only care about the terms in this page
    for bufnr in tabpagebuflist()
        " if !bufexists(bufnr)
        "     continue
        " endif
        let l:buftype = nvim_buf_get_option(bufnr, "buftype")
        if l:buftype == "terminal"
            call add(l:terminals, bufnr)
        endif
    endfor
    return l:terminals
endfunction
