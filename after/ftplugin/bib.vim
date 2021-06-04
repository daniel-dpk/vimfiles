" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim


" Customizations
setlocal iskeyword+=:
setlocal iskeyword+=-
setlocal iskeyword+=.


" Restore the previous cpo.
let &cpo = s:save_cpo
