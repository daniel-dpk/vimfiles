let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> <silent> <LocalLeader>C :let @+=substitute(getline("."), "^[ \t]*", "", "")<CR>
nnoremap <buffer> <silent> <LocalLeader>c :call <SID>CopyCodeBlock()<CR>
function! s:CopyCodeBlock()
    let l:start = search('^\s*```', 'bnW') + 1
    let l:end = search('^\s*```$', 'nW') - 1
    if l:start > 1 && l:end >= l:start
        let l:lines = getline(l:start, l:end)
        let l:min_indent = min(map(copy(l:lines), {_, v -> len(matchstr(v, '^\s*'))}))
        let l:lines = map(l:lines, {_, v -> substitute(v, '^\s\{' . l:min_indent . '\}', '', '')})
        let l:result = join(l:lines, "\n")
        if len(l:lines) > 1
            let l:result = l:result . "\n"
        endif
        let @+ = l:result
        echo len(l:lines) . ' line(s) yanked into "+'
    else
        echo "No code block found."
    endif
endfunction

nnoremap <buffer> <silent> <LocalLeader><LocalLeader>p o<Esc>a```python<CR>```<Esc>O<Tab>
vnoremap <buffer> <silent> <LocalLeader><LocalLeader>p <Esc>`>o<Esc>a```<Esc>`<O<Esc>a```python<Esc>j

nnoremap <buffer> <silent> <LocalLeader><LocalLeader>c o<Esc>a```cpp<CR>```<Esc>O<Tab>
vnoremap <buffer> <silent> <LocalLeader><LocalLeader>c <Esc>`>o<Esc>a```<Esc>`<O<Esc>a```cpp<Esc>j

nnoremap <buffer> <silent> <LocalLeader><LocalLeader>s o<Esc>a```sh<CR>```<Esc>O<Tab>
vnoremap <buffer> <silent> <LocalLeader><LocalLeader>s <Esc>`>o<Esc>a```<Esc>`<O<Esc>a```sh<Esc>j

nnoremap <buffer> <silent> <LocalLeader><LocalLeader>t o<Esc>a```<CR>```<Esc>O<Tab>
vnoremap <buffer> <silent> <LocalLeader><LocalLeader>t <Esc>`>o<Esc>a```<Esc>`<O<Esc>a```<Esc>j


nnoremap <buffer> <silent> <A-k> :call <SID>search("^# Tags: ", 'bWs', 'n')<CR>
nnoremap <buffer> <silent> <A-j> :call <SID>search("^# Tags: ", 'Ws', 'n')<CR>
vnoremap <buffer> <silent> <A-k> :call <SID>search("^# Tags: ", 'bWs', 'v')<CR>
vnoremap <buffer> <silent> <A-j> :call <SID>search("^# Tags: ", 'Ws', 'v')<CR>

function! s:search(pattern, flags, mode)
    if a:mode ==# 'v'
        normal! gv
    endif
    call search(a:pattern, a:flags)
endfunction

let &cpo = s:save_cpo
