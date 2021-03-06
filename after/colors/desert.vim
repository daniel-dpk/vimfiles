" This tweaks the "desert.vim" colorscheme. For this to work, the
" AfterColors.vim plug-in needs to be installed.
" See: https://github.com/vim-scripts/AfterColors.vim

" Search: term=reverse ctermfg=248 ctermbg=12 guifg=wheat guibg=peru
highlight Search ctermfg=0 ctermbg=3

" Highlighting matching parentheses
" (in the terminal, it is difficult to tell where the cursor is)
highlight MatchParen cterm=NONE ctermbg=DarkBlue ctermfg=White

highlight NonText guibg=NONE
highlight link NonText Normal
