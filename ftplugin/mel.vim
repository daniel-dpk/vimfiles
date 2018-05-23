if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim

let b:undo_ftplugin = "setlocal formatoptions< comments< dictionary< path< "
						\ . "include< cinoptions<"

setlocal formatoptions=cqlr

" Configure indenting to not indent cases with braces.
setlocal cinoptions=l1,b1

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,
			\f://\ MARK,sb://\ TODO:,mb://,e://,://

setlocal include=^\\s*\\%(\\/\\/\\)\\?\\s*#\\?\\s*\\%(include\\\|source\\)


" Quickly jump between functions
noremap <buffer> <silent> <A-k> :call search("^\\w", 'bW')<CR>
noremap <buffer> <silent> <A-j> :call search("^\\w", 'W')<CR>


" Search for all TODOs in the source
noremap <buffer> <a-O> :vimgrep /\<TODO:/j **/*.mel <Bar> :cope<CR>


" Restore the previous cpo.
let &cpo = s:save_cpo
