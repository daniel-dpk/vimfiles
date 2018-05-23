" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" We'll conform to the clang-format suggestions (style: google), except for ts=4 sw=4
setlocal textwidth=80
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

setlocal iskeyword=a-z,A-Z,48-57,_
setlocal nowrap
setlocal showbreak=\ \ \ \ \ \ \ \ 

setlocal autoread

setlocal formatoptions=c  " break comment lines
setlocal formatoptions+=q " format comments with "gq"
setlocal formatoptions+=l " don't break already long lines
setlocal formatoptions+=r " insert comment leader when hitting <CR>

" Configure indenting to not indent cases with braces.
setlocal cinoptions=l1,b1

" This is the comment style for embedded doxygen documentation.
let s:comments = escape( &comments, '" \' )
execute "setlocal comments=sb://!\\ \\\\brief,mb://!,e://!,://!,".s:comments
unlet s:comments


"------------"
"  Mappings  "
"------------"

" ALT-k and ALT-j will jump up and down between functions or classes
noremap <buffer> <silent> <A-k> :call search("^\\%(public:\\\|private:\\\|protected:\\\|template \\\|[ \\t}\\/#]\\)\\@!\\w", 'bWs')<CR>
noremap <buffer> <silent> <A-j> :call search("^\\%(public:\\\|private:\\\|protected:\\\|template \\\|[ \\t}\\/#]\\)\\@!\\w", 'Ws')<CR>

" Search for all TODOs in the source
noremap <buffer> <a-O> :vimgrep /\<TODO:/j **/*.c **/*.cpp **/*.h <Bar> :cope<CR>

" Quickly switch between header/implementation/test files.
noremap <buffer> <silent> <LocalLeader>e :call ft#cpp#ToggleHeaderImpl(0)<CR>
noremap <buffer> <silent> <LocalLeader>E :call ft#cpp#ToggleHeaderImpl(1)<CR>
noremap <buffer> <silent> <LocalLeader>t :call ft#cpp#ToggleTestImpl(0)<CR>
noremap <buffer> <silent> <LocalLeader>T :call ft#cpp#ToggleTestImpl(1)<CR>


" Restore the previous cpo.
let &cpo = s:save_cpo
