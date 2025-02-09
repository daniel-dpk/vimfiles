" This tweaks the "hybrid.vim" colorscheme. For this to work, the
" AfterColors.vim plug-in needs to be installed.
" See: https://github.com/vim-scripts/AfterColors.vim

" Search (#f0c674)
"highlight Search guibg=#AF9056
highlight Search guibg=#997E4C
"highlight Search guibg=#876F43

" Highlighting matching parentheses
" (in the terminal, it is difficult to tell where the cursor is)
highlight MatchParen cterm=NONE ctermbg=DarkBlue ctermfg=White

" Folded (default: guibg=#1c1c1c guifg=#707880)
"highlight Folded guibg=#232323
"highlight Folded guibg=#262626 guifg=#4E545B
highlight Folded guibg=#262626

" This is a folded line with some empty lines {{{




" }}}

" FoldColumn (fg:NONE, bg:#1c1c1c)
highlight FoldColumn guifg=#666666

" LineNr (#373b41)
"highlight LineNr guifg=#454A51
"highlight LineNr guifg=#4E545B
"highlight LineNr guifg=#707880

" Tab line (top of screen)
highlight TabLine     term=NONE cterm=NONE ctermfg=White ctermbg=235      gui=NONE guifg=White guibg=#333333
highlight TabLineFill term=NONE cterm=NONE ctermfg=White ctermbg=235      gui=NONE guifg=White guibg=#333333
highlight TabLineSel  term=NONE cterm=NONE ctermfg=White ctermbg=DarkGray gui=NONE guifg=White guibg=#666666

" String (fg:#b5bd68, bg:NONE)
"highlight String guifg=#B6BA93 guibg=#292929
"highlight String guifg=#a0a0a0 guibg=#292929
highlight String guifg=#a0a0a0 guibg=#232323


highlight SpecialComment1 gui=bold
highlight Fade guifg=#4E545B guibg=NONE
