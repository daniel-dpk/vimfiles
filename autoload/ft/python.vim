function! ft#python#ToggleTestImpl(createIfNotExisting)
    let l:dir = expand("%:p:h") . "/"
    let l:fname = expand("%:t:r")
    let l:ext = "." . expand("%:e")
    if l:fname =~? "^test_"
        let l:nontestfilename = substitute(l:fname, "^test_", "", "") . l:ext
        call s:OpenOrCreate(l:nontestfilename, l:dir, a:createIfNotExisting)
    else
        let l:testfilename = "test_" . l:fname . l:ext
        call s:OpenOrCreate(l:testfilename, l:dir, a:createIfNotExisting)
    endif
endfunction

function! s:OpenOrCreate(fname, dir, createIfNotExisting)
    let l:fullfname = a:dir . a:fname
    if !s:TryToEdit(l:fullfname)
        if a:createIfNotExisting
            if s:AskYesNo("Create file '" . a:fname . "'?")
                execute "edit " . l:fullfname
                set ff=unix
                return
            endif
        endif
        echohl WarningMsg
        echomsg "File not found: " . l:fullfname
        echohl None
    endif
endfunction

function! s:AskYesNo(msg)
    let l:result = 0
    call inputsave()
    echohl Question
    if input(a:msg . " [y/N] ") =~? '^y\(es\)\?$'
        let l:result = 1
    endif
    echohl None
    call inputrestore()
    return l:result
endfunction

function! s:TryToEdit(fname)
    if filereadable(a:fname)
        execute "edit " . a:fname
        return 1
    endif
    return 0
endfunction

" Taken from: https://stackoverflow.com/a/4028423
function! ft#python#GetPythonTextWidth()
    if !exists('g:python_normal_text_width')
        let l:normal_text_width = 79
    else
        let l:normal_text_width = g:python_normal_text_width
    endif

    if !exists('g:python_comment_text_width')
        let l:comment_text_width = 72
    else
        let l:comment_text_width = g:python_comment_text_width
    endif

    let cur_syntax = synIDattr(synIDtrans(synID(line("."), max([1, col(".")-1]), 0)), "name")
    if cur_syntax == "Comment"
        return l:comment_text_width
    elseif cur_syntax == "String"
        " Check to see if we're in a docstring
        let lnum = line(".")
        while lnum >= 1 && (synIDattr(synIDtrans(synID(lnum, col([lnum, "$"]) - 1, 0)), "name") == "String" || match(getline(lnum), '\v^\s*$') > -1)
            if match(getline(lnum), "\\('''\\|\"\"\"\\)") > -1
                " Assume that any longstring is a docstring
                return l:comment_text_width
            endif
            let lnum -= 1
        endwhile
    endif

    return l:normal_text_width
endfunction
