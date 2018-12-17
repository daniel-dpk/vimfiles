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
	return strlen(matchstr(a:line,'\v^\s+'))
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
  let numLines = v:foldend - v:foldstart + 1
	return line.' ['.numLines.' lines]'
endfunction

nnoremap <buffer> <silent> <LocalLeader>x yyp_C[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>t yyp_C[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>s yyp_C<tab>[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>X yyP_C[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>T yyP_C[ ]<space>
nnoremap <buffer> <silent> <LocalLeader>S yyP_C<tab>[ ]<space>

noremap <buffer> <silent> <A-k> :call search("^\\* \\S", 'bWs')<CR>
noremap <buffer> <silent> <A-j> :call search("^\\* \\S", 'Ws')<CR>

nnoremap <buffer> <silent> <space> za

nnoremap <buffer> <silent> <LocalLeader><space> :call <SID>ToggleTodo()<CR>
function! s:ToggleTodo()
    let l:line = getline('.')
    let l:char = matchstr(l:line, '\[\zs.\ze\]')
    if l:char == 'x'
        let l:char = ' '
    else
        let l:char = 'x'
    endif
    call setline(line('.'), substitute(l:line, '\[\zs.\ze]', l:char, ''))
endfunction


" Restore the previous cpo.
let &cpo = s:save_cpo
