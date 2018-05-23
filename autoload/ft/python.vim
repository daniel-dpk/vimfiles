function! ft#python#ToggleTestImpl(createIfNotExisting)
    let l:dir = expand("%:p:h") . "/"
    let l:fname = expand("%:t:r")
    let l:ext = "." . expand("%:e")
    if l:fname =~? "^test_"
        let l:nontest = l:dir . substitute(l:fname, "^test_", "", "") . l:ext
        if !s:TryToEdit(l:nontest)
            echomsg "Corresponding non-test file not found: " . l:nontest
        endif
    else
        let l:testfilename = "test_" . l:fname . l:ext
        let l:testfile = l:dir . l:testfilename
        if !s:TryToEdit(l:testfile)
            if a:createIfNotExisting
                if s:AskYesNo("Create file '" . l:testfilename . "'?")
                    execute "edit " . l:testfile
                    set ff=unix
                    return
                endif
            endif
            echomsg "Corresponding test file not found: " . l:testfile
        endif
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
