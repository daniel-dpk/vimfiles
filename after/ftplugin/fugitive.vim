" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
nnoremap <buffer> <silent> q :q<CR>
nmap <buffer> <silent> <tab> =


" Restore the previous cpo.
let &cpo = s:save_cpo
