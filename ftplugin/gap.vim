if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" Store the cpo and set it to the vim default.
let s:save_cpo = &cpo
set cpo&vim

let b:undo_ftplugin = "setlocal complete< comments< et< sw< ts< tw< fdc< fdm< fde< fdt<"

" for word completion, fall back to list of GAP global variable names
" (after loading your favourite packages in GAP say:
" for w in NamesGVars() do AppendTo("~/.vim/GAPWORDS",w,"\n"); od;    )
set complete=.,w,b,u,t,i,k~/vimfiles/GAPWORDS

setlocal comments=:#
setlocal et
setlocal sw=4
setlocal ts=4
setlocal tw=100
setlocal foldcolumn=0


" Restore the previous cpo.
let &cpo = s:save_cpo
