" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
setlocal formatoptions-=o
setlocal nowrap
setlocal foldmarker=\ {{{,\ }}}


" Restore the previous cpo.
let &cpo = s:save_cpo
