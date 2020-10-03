" Terminal related utility functions

" TODO(alvaro): Add better error handling
function! utils#term#TermSendCmd(cmd)
    " This sends a command to the terminal, but does not care about what it
    " sends back
    let l:curr_winnr = winnr()

    "
    let l:terminals = utils#term#GetTermBufnr()
    if len(l:terminals) == 0
        call utils#term#OpenTerm(20)
        " TODO(alvaro): Add a way to detect that the terminal is ready to take
        "    commands since now the command is being printed twice
        " try again to get the terminal bufnr
        let l:terminals = utils#term#GetTermBufnr()
        if len(l:terminals) != 1
            echoerr "failed to start a new terminal to run the command"
            return
        endif
    elseif len(l:terminals) > 1
        echoerr "found multiple terminals open"
        return
    endif

    let l:term_bufnr = l:terminals[0]
    if l:term_bufnr < 1
        " NOTE(alvaro): Since we changed to GetTermBufnr() we should never get
        "    to this point
        echoerr "invalid terminal bufnr"
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

    " Make sure we are srolled down in the window running the terminal
    let l:term_winnr = bufwinnr(l:term_bufnr)
    execute l:term_winnr . "wincmd w"
    " Scroll until the end
    silent normal G
    execute l:curr_winnr . "wincmd w"
endfunction

function! utils#term#GetTermBufnr()
    " TODO(alvaro): This does not take into account the terminal buffers
    "     that may be hidden (not in any window currenty). We want to take
    "     those into account? How would we bring those up to a relevant
    "     position anyway?
    "     For now, this will create new terminal buffers if you fail to close
    "     them correctly (such as :q in normal mode in a term buffer)
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
    " TODO(alvaro): If no visible terminal is here, we maybe can show the
    " hidden one in a vertical split, just linke utils#term#OpenTerm would do
    return l:terminals
endfunction

function! utils#term#OpenTerm(size)
    " TODO(alvaro): Add split direction support?
    " FIXME(alvaro): Use a more portable way of opening a terminal here
    "     maybe use jobstart or something similar
    let l:open_term_command = a:size . "split +term"
    execute l:open_term_command

    " Move the cursor back to the previous window
    wincmd p
    " Leave the cursor in normal mode
    call feedkeys("\<ESC>")
endfunction
