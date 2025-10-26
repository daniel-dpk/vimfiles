if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim

let b:undo_ftplugin = "setlocal comments< et< sw< ts< tw< fdc< fdm< fde< fdt<"

setlocal comments=fb:-,fb:*,fb:[\ ]
setlocal et
setlocal sw=4
setlocal ts=4
setlocal tw=100
setlocal foldcolumn=0

function! TSIndent(line)
    return strlen(matchstr(a:line,'\v^\s+')) / &shiftwidth
endfunction
setlocal foldmethod=expr
setlocal foldexpr=MyTSIndentFoldExpr()
function! MyTSIndentFoldExpr()
    if (getline(v:lnum)=~'^$')
        return 0
    endif
    let ind = TSIndent(getline(v:lnum))
    let indNext = TSIndent(getline(v:lnum+1))
    return (ind<indNext) ? ('>'.(indNext)) : ind
endfunction
setlocal foldtext=MyFoldText()
function! MyFoldText()
    let line = getline(v:foldstart)
    " Foldtext ignores tabstop and shows tabs as one space,
    " so convert tabs to 'tabstop' spaces so text lines up
    let ts = repeat(' ',&tabstop)
    let line = substitute(line, '\t', ts, 'g')
    let line = substitute(line, '^\(\s*\)\*', '\1▶', '')
    let line = substitute(line, '^\(\s*\)  [', '\1⋯ [', '')
    let numLines = v:foldend - v:foldstart + 1
    return line.' ['.numLines.' lines]'
endfunction

" Restore default background on folded lines since we indicate folding via symbols.
if has("gui_running")
    exec 'hi Folded giobg=' . synIDattr(hlID('Normal'),'bg')
else
    exec 'hi Folded ctermbg=NONE'
endif

nnoremap <buffer> <silent> <LocalLeader>x yyp_C[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>t yyp_C[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>S yyp_C<tab>[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>X yyP_C[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>T yyP_C[ ]<space>

noremap <buffer> <silent> <A-k> :call search("^\\* \\S", 'bWs')<CR>
noremap <buffer> <silent> <A-j> :call search("^\\* \\S", 'Ws')<CR>

nnoremap <buffer> <silent> <S-space> za

nnoremap <buffer> <silent> <LocalLeader><space> :call <SID>ToggleTodo("x", "done")<CR>
nnoremap <buffer> <silent> <LocalLeader>C :call <SID>ToggleTodo("-", "cancelled")<CR>
function! s:ToggleTodo(donechar, donestr)
    let l:line = getline('.')
    let l:char = matchstr(l:line, '\[\zs.\ze\]')
    if l:char == a:donechar
        let l:char = ' '
        let l:line = substitute(l:line, '@'.a:donestr.' [^@]\+', '', '')
        let l:line = substitute(l:line, '\s*$', '', '')
    else
        let l:char = a:donechar
        let l:line = printf("%-120s @%s %s", l:line, a:donestr, strftime("%Y-%m-%d %H:%M"))
    endif
    let l:line = substitute(l:line, '\[\zs.\ze]', l:char, '')
    call setline(line('.'), l:line)
endfunction


" Restore the previous cpo.
let &cpo = s:save_cpo
