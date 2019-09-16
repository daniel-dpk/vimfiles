function! ft#cpp#ToggleHeaderImpl(createIfNotExisting)
    let l:ext   = expand("%:e")
    let l:path = expand("%:p:h")
    let l:base = expand("%:t:r")
    if l:ext =~? "cpp\\|cxx\\|c"
        if !s:TryToEdit(l:path, l:base, ["h", "hpp"], [".", "include"])
            let l:base_shortened = substitute(l:base, "_[^_]\\+$", "", "")
            if !s:TryToEdit(l:path, l:base_shortened, ["h", "hpp"])
                if a:createIfNotExisting
                    execute "edit " . l:path . "/" . l:base . ".h"
                    set ff=unix
                else
                    echomsg "No corresponding header found."
                endif
            endif
        endif
    else
        if !s:TryToEdit(l:path, l:base, ["cpp", "c", "cxx"], [".", ".."])
            if a:createIfNotExisting
                execute "edit " . l:path . "/" . l:base . ".cpp"
                set ff=unix
            else
                echomsg "No corresponding implementation found."
            endif
        endif
    endif
endfunction

function! ft#cpp#ToggleTestImpl(createIfNotExisting)
    let l:ext   = expand("%:e")
    let l:path = expand("%:p:h")
    let l:base = expand("%:t:r")
    if l:base =~? "Test$"
        let l:base = substitute(l:base, "Test$", "", "")
        if !s:TryToEdit(l:path, l:base, ["cpp", "c", "h"])
            echomsg "No corresponding non-test file found."
        endif
    else
        if !s:TryToEdit(l:path, l:base . "Test", ["cpp", "c"])
            if a:createIfNotExisting
                execute "edit " . l:path . "/" . l:base . "Test.cpp"
                set ff=unix
            else
                echomsg "No corresponding test file found."
            endif
        endif
    endif
endfunction

function! s:TryToEdit(path, basename, exts, ...)
    let l:dirs = a:0 >= 1 ? a:1 : ["."]
    if a:0 > 1
        throw "Too many arguments on call to s:TryToEdit()."
    endif
    for l:ext in a:exts
        for l:dir in l:dirs
            let l:fname = a:path . "/" . l:dir . "/" . a:basename . "." . l:ext
            "echomsg "Looking for " . l:fname
            if filereadable(l:fname)
                execute "edit " . l:fname
                return 1
            endif
        endfor
    endfor
    return 0
endfunction
