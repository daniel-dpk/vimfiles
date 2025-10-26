" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
nnoremap <buffer> <silent> q :q<CR>
nmap <buffer> <silent> <tab> 1p
nmap <buffer> <silent> K k1p
nmap <buffer> <silent> J j1p


" Restore the previous cpo.
let &cpo = s:save_cpo
