" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
setlocal textwidth=72
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal spell


" Restore the previous cpo.
let &cpo = s:save_cpo
