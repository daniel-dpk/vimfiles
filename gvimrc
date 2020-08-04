" Personal GVim configuration of Daniel Pook-Kolb
" Maintainer: Daniel Pook-Kolb <daniel@dpk.stargrav.com>
" License:    MIT (see LICENSE.txt)


" General GUI
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L
set tabpagemax=30 " maximum number of tabs

" Disable beep and flashing
set visualbell
set t_vb=


" Fonts
if has("win32")
    set guifont=Consolas:h10:cANSI
    set linespace=0
else
    set guifont=Luxi\ Mono\ 10
    set linespace=0
endif


" Initial window size
set lines=51
if &diff
    set columns=250
else
    set columns=120
endif


" vim:set ts=4 sw=4 sts=4 et tw=78 fdm=marker:
