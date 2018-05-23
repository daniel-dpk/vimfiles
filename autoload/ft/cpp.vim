function! ft#cpp#ToggleHeaderImpl(createIfNotExisting)
    let l:ext   = expand("%:e")
    let l:fname = expand("%:p:r")
    if l:ext =~? "cpp\\|cxx\\|c"
        if !s:TryToEdit(l:fname . ".h") && !s:TryToEdit(l:fname . ".hpp")
            let l:fname_shortened = substitute(l:fname, "_[^_]\\+$", "", "")
            if !s:TryToEdit(l:fname_shortened . ".h") && !s:TryToEdit(l:fname_shortened . ".hpp")
                if a:createIfNotExisting
                    execute "edit " . l:fname . ".h"
                    set ff=unix
                else
                    echomsg "No corresponding header found."
                endif
            endif
        endif
    else
        if !s:TryToEdit(l:fname . ".cpp") && !s:TryToEdit(l:fname . ".c") && !s:TryToEdit(l:fname . ".cxx")
            if a:createIfNotExisting
                execute "edit " . l:fname . ".cpp"
                set ff=unix
            else
                echomsg "No corresponding implementation found."
            endif
        endif
    endif
endfunction

function! ft#cpp#ToggleTestImpl(createIfNotExisting)
    let l:fname = expand("%:p:r")
    if l:fname =~? "Test$"
        let l:fname = substitute(l:fname, "Test$", "", "")
        if !s:TryToEdit(l:fname . ".cpp") && !s:TryToEdit(l:fname . ".c") && !s:TryToEdit(l:fname . ".h")
            echomsg "No corresponding non-test file found."
        endif
    else
        if !s:TryToEdit(l:fname . "Test.cpp") && !s:TryToEdit(l:fname . "Test.c")
            if a:createIfNotExisting
                execute "edit " . l:fname . "Test.cpp"
                set ff=unix
            else
                echomsg "No corresponding test file found."
            endif
        endif
    endif
endfunction

function! s:TryToEdit(fname)
    if filereadable(a:fname)
        execute "edit " . a:fname
        return 1
    endif
    return 0
endfunction
