" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Search for all TODOs in the source
noremap <buffer> <a-O> :vimgrep /\<TODO:/j **/*.php <Bar> :cope<CR>


" Restore the previous cpo.
let &cpo = s:save_cpo
