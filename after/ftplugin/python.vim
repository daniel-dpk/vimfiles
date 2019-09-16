" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Search for all TODOs in the source
noremap <buffer> <a-O> :vimgrep /\(\<TODO\\|@todo\):/j **/*.py <Bar> :cope<CR>

" Quickly jump between functions/classes
nnoremap <buffer> <silent> <C-Up> :call <SID>search("^\\(class\\\|def\\) ", 'bWs', 'n')<CR>
nnoremap <buffer> <silent> <C-Down> :call <SID>search("^\\(class\\\|def\\) ", 'Ws', 'n')<CR>
vnoremap <buffer> <silent> <C-Up> :call <SID>search("^\\(class\\\|def\\) ", 'bWs', 'v')<CR>
vnoremap <buffer> <silent> <C-Down> :call <SID>search("^\\(class\\\|def\\) ", 'Ws', 'v')<CR>
nnoremap <buffer> <silent> <A-k> :call <SID>search("^\\s*\\(class\\\|def\\) ", 'bWs', 'n')<CR>
nnoremap <buffer> <silent> <A-j> :call <SID>search("^\\s*\\(class\\\|def\\) ", 'Ws', 'n')<CR>
vnoremap <buffer> <silent> <A-k> :call <SID>search("^\\s*\\(class\\\|def\\) ", 'bWs', 'v')<CR>
vnoremap <buffer> <silent> <A-j> :call <SID>search("^\\s*\\(class\\\|def\\) ", 'Ws', 'v')<CR>

function! s:search(pattern, flags, mode)
    if a:mode ==# 'v'
        normal! gv
    endif
    call search(a:pattern, a:flags)
endfunction

" Quickly switch between main and test files.
noremap <buffer> <silent> <LocalLeader>t :call ft#python#ToggleTestImpl(0)<CR>
noremap <buffer> <silent> <LocalLeader>T :call ft#python#ToggleTestImpl(1)<CR>


"" Uncomment to get auto-textwidth for code vs. comments/docstrings.
"" Test width in normal text vs. comments/docstrings.
"let g:python_normal_text_width = 78
"let g:python_comment_text_width = 72
"augroup pep8textwidth
"    au!
"    autocmd InsertEnter *
"                \ :if &ft == 'python' || &ft == 'pyrex' |
"                \ :exe 'setlocal textwidth='.ft#python#GetPythonTextWidth() |
"                \ :endif
"augroup END
"
"vnoremap <buffer> <silent> gq :<C-U>exe 'setlocal textwidth='.ft#python#GetPythonTextWidth()<CR>gvgq


" Restore the previous cpo.
let &cpo = s:save_cpo
