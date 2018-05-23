" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
setlocal formatoptions-=t
setlocal formatoptions-=o
setlocal formatoptions+=l
setlocal formatoptions+=r

setlocal nowrap


" Restore the previous cpo.
let &cpo = s:save_cpo
