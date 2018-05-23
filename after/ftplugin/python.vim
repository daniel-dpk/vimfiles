" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Search for all TODOs in the source
noremap <buffer> <a-O> :vimgrep /\(\<TODO\\|@todo\):/j **/*.py <Bar> :cope<CR>

" Quickly jump between functions/classes
nnoremap <buffer> <silent> <A-k> :call <SID>search("^\\(class\\\|def\\) ", 'bWs', 'n')<CR>
nnoremap <buffer> <silent> <A-j> :call <SID>search("^\\(class\\\|def\\) ", 'Ws', 'n')<CR>
vnoremap <buffer> <silent> <A-k> :call <SID>search("^\\(class\\\|def\\) ", 'bWs', 'v')<CR>
vnoremap <buffer> <silent> <A-j> :call <SID>search("^\\(class\\\|def\\) ", 'Ws', 'v')<CR>

function! s:search(pattern, flags, mode)
    if a:mode ==# 'v'
        normal! gv
    endif
    call search(a:pattern, a:flags)
endfunction


" Restore the previous cpo.
let &cpo = s:save_cpo
