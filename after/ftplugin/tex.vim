" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
setlocal foldmarker=\ {{{,\ }}}


" Toggle spell checking in comments
noremap <buffer> <S-F4> <Esc>:let tex_comment_nospell=!g:tex_comment_nospell<CR>
			\<Esc>:set ft=tex spell<CR>

" Quickly jump between chapters/sections
nnoremap <buffer> <silent> <A-k> :call <SID>search("^\\\\\\(chapter\\\|\\(sub\\\|subsub\\)\\?section\\)\\({\\\|[\\)", 'bWs', 'n')<CR>
nnoremap <buffer> <silent> <A-j> :call <SID>search("^\\\\\\(chapter\\\|\\(sub\\\|subsub\\)\\?section\\)\\({\\\|[\\)", 'Ws', 'n')<CR>

function! s:search(pattern, flags, mode)
	if a:mode ==# 'v'
		normal! gv
	endif
	call search(a:pattern, a:flags)
endfunction


" Search for all TODOs in the source
noremap <buffer> <a-O> :vimgrep /\(\<TODO\\|@todo\)\>/j **/*.tex <Bar> :cope<CR>


inoremap <buffer> <A-x> <c-g>u\text{}<Esc>i
inoremap <buffer> <A-q> <c-g>u\quad
inoremap <buffer> <A-Q> <c-g>u\qquad
inoremap <buffer> <A-.> <c-g>u\ldots

" Toggle "_" and ":" to be keyword characters with ",_" and ",:", respectively
nnoremap <silent> <buffer> <LocalLeader>_ :call <SID>ToggleCharKeyword('_')<CR>
nnoremap <silent> <buffer> <LocalLeader>: :call <SID>ToggleCharKeyword(':')<CR>
function! s:ToggleCharKeyword(char)
	if &iskeyword =~ a:char
		execute "setlocal iskeyword-=" . a:char
		echo "Removed '" . a:char . "' from 'iskeyword'"
	else
		execute "setlocal iskeyword+=" . a:char
		echo "Added '" . a:char . "' to 'iskeyword'"
	endif
endfunction

" Bold/italic/emph mappings
nnoremap <buffer> <LocalLeader>b a{\bfseries }<Esc>i
vnoremap <buffer> <LocalLeader>b <Esc>`>a}<Esc>`<i{\bfseries <Esc>
nnoremap <buffer> <LocalLeader>i a{\itshape }<Esc>i
vnoremap <buffer> <LocalLeader>i <Esc>`>a}<Esc>`<i{\itshape <Esc>
nnoremap <buffer> <LocalLeader>e a{\em }<Esc>i
vnoremap <buffer> <LocalLeader>e <Esc>`>a}<Esc>`<i{\em <Esc>


" Restore the previous cpo.
let &cpo = s:save_cpo
