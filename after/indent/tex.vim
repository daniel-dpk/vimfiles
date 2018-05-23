" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
setlocal autoindent
setlocal indentexpr=""


" Restore the previous cpo.
let &cpo = s:save_cpo
