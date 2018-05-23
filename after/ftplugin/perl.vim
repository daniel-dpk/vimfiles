" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
setlocal include=
setlocal formatoptions-=o
setlocal formatoptions-=t
setlocal formatoptions+=r
setlocal nowrap
setlocal iskeyword-=:

" Start a search to quickly find the definition of a subroutine.
nmap <buffer> <LocalLeader>/ /^sub<SPACE>

" Find the subroutine under the cursor.
nmap <buffer> <LocalLeader># ?<C-R><C-W>\><HOME>^sub<SPACE><CR>
nmap <buffer> <LocalLeader>* /<C-R><C-W>\><HOME>^sub<SPACE><CR>


" Restore the previous cpo.
let &cpo = s:save_cpo
