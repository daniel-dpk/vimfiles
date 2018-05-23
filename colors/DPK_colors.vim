" Vim color file
" Maintainer: Daniel Pook-Kolb <daniel@dpk.stargrav.com>
" Last Change: Jan 03, 2007
"
" Note:
"   This colorscheme can be loaded in either soft or harsh mode. In soft mode
"   (the default), the colors are very easy on the eyes and have a low
"   saturation and contrast. This mode has a light grey background.
"
"   The harsh mode has a white background and most colors have a high
"   saturation. Editing a file that has many highlighted items will show a
"   very colored image with high contrast. I found this to be a little too
"   much for my eyes, depending what filetype I was editing.
"
"
"   You can choose the mode by setting a global vim variable BEFORE loading
"   the colorscheme. This could e.g. be done inside your vimrc file. There are
"   other options too. Here's the explanation.
"
"   This will enable soft colors (e.g. after you've used harsh colors):
"     let g:dpk_harsh_colors = 0
"
"   This will enable harsh colors:
"     let g:dpk_harsh_colors = 1
"
"   For soft-colors designed for being printed (i.e. white pagecolor)
"     let g:dpk_harsh_colors = -1
"
"   By default, error and warning messages have a yellow background, just like
"   visual selection. To show them with the more prominent red background
"   simply use these lines in your vimrc.
"     let g:dpk_soft_errorMsg   = 0
"     let g:dpk_soft_warningMsg = 0
"
"   Items with Ignore highlighting have a very faint color, so that they are
"   barely visible. If you want to hide them completely, use this line.
"     let g:dpk_ignore_invisible = 1
"
"
"   When you specify your own syntax file, you can use the following otherwise
"   undocumented highlighting groups:
"     SpecialCommentNotes - Pink text within comments (e.g. for NOTE)
"     SpecialComment1     - Like SpecialComment, but much more pronounced
"     SpecialComment2     - Like SpecialComment, but more pronounced
"     Fade                - Like Ignore when dpk_ignore_invisible is 0
"   To make your syntax file work with other colorschemes, please link these
"   groups to their more commonly used related groups like this:
"     hi def link SpecialComment1     SpecialComment
"     hi def link SpecialComment2     SpecialComment
"     hi def link SpecialCommentNotes Special
"     hi def link Fade                Ignore
"
"
" Examples:
"   Enter the following in your vimrc to show the DPK colorscheme with soft
"   colors.
"     color DPK_colors
"
"   Enter the following in your vimrc to show the DPK colorscheme with harsh
"   colors.
"     let g:dpk_harsh_colors = 1
"     color DPK_colors
"
"   The following line will map a command to the <F4> key that toggles between
"   soft and harsh colors.
"     map <F4> :let g:dpk_harsh_colors=!g:dpk_harsh_colors<CR>:colo DPK_colors<CR>


" Preparations {{{1
" Initial Steps {{{2
set background=light
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "DPK_colors"


" HiGui {{{2
" This does auto completion of a hex that is too short for a color.
function! s:fnCompleteHex( color )
    let l:hex = matchstr( a:color, "^#[0-9A-Fa-f]*$" )
    if strlen(l:hex) == 0
        return a:color
    endif

    let l:hex  = strpart( l:hex, 1 )
    let l:size = strlen(  l:hex )

    if     l:size == 1
        let l:hex = l:hex.l:hex.l:hex.l:hex.l:hex.l:hex
    elseif l:size == 2
        let l:hex = l:hex.l:hex.l:hex
    elseif l:size == 3
        let l:h1 = strpart( l:hex, 0, 1 )
        let l:h2 = strpart( l:hex, 1, 1 )
        let l:h3 = strpart( l:hex, 2, 2 )
        let l:hex = l:h1.l:h1.l:h2.l:h2.l:h3.l:h3
    elseif l:size == 4
        let l:hex = l:hex."00"
    elseif l:size == 5
        let l:hex = l:hex."0"
    endif

    return "#".l:hex
endfunction


" Define a function to quickly specify attributes for one highlighting group.
function! s:fnHiGui( grp, ... )
    " Get the number of additional arguments.
    let l:numArgs = a:0

    " Get the arguments.
    let l:fg   = 'fg'
    let l:bg   = 'bg'
    let l:attr = 'NONE'
    if l:numArgs >= 1 | let l:fg   = a:1 | endif
    if l:numArgs >= 2 | let l:bg   = a:2 | endif
    if l:numArgs == 3 | let l:attr = a:3 | endif
    if l:numArgs >  3
        echoerr "Too many arguments on call to fnHiGui!"
        return 1;
    endif

    " Complete unfinished hex colors.
    let l:fg = s:fnCompleteHex( l:fg )
    let l:bg = s:fnCompleteHex( l:bg )

    " Complete unfinished attributes.
    let l:attr = substitute( l:attr, '\(^\|,\)b\($\|,\)', '\1bold\2',     "" )
    let l:attr = substitute( l:attr, '\(^\|,\)u\($\|,\)', '\1underline\2',"" )
    let l:attr = substitute( l:attr, '\(^\|,\)r\($\|,\)', '\1reverse\2',  "" )
    let l:attr = substitute( l:attr, '\(^\|,\)i\($\|,\)', '\1italic\2',   "" )
    let l:attr = substitute( l:attr, '\(^\|,\)s\($\|,\)', '\1standout\2', "" )

    " Build and execute the highlight command.
    execute 'highlight '.a:grp.' gui='.l:attr.' guifg='.l:fg.' guibg='.l:bg
endfunction

" Create a temporary command to use inside this script. We'll delete it when
" we're finished.
command! -nargs=+ HiGui call s:fnHiGui(<f-args>)


" InitOption {{{2
" Define another function for initializing options of this color file. It will
" ensure a local variable for the specified option exists. If the
" corresponding global variable exists, its value is used. Otherwise, a given
" default will be used.
function! s:fnInitOption( option, default )
    if !exists("g:dpk_".a:option)
        " The global variable doesn't exist, so we create the local variable
        " and initialize it with the default value.
        let s:{a:option} = a:default
    else
        " The global variable exists, so we'll initialize the local variable
        " with its value.
        let s:{a:option} = g:dpk_{a:option}
    endif
endfunction

" To allow convenient usage of this function, we'll create a temporary
" command for it.
command! -nargs=+ InitOption call s:fnInitOption(<f-args>)


" Parse/Initialize the options {{{2
InitOption harsh_colors     0
InitOption soft_errorMsg    1
InitOption soft_warningMsg  1
InitOption ignore_invisible 0
" }}}1


" GUI coloring {{{1
if s:harsh_colors == 1
    " Harsh colors {{{2
    " Non-Syntax highlight groups: {{{3
    HiGui Normal        #0          #f
    HiGui Cursor        bg          fg
    HiGui SignColumn    #000080     #c0
    HiGui Visual        #0          #ff0
    HiGui VisualNOS     fg          bg              b,u
    HiGui DiffAdd       fg          #a0a0ff
    HiGui DiffChange    fg          #ffa0ff
    HiGui DiffDelete    #00f        #a0ffff         b
    HiGui DiffText      fg          #f00            b
    HiGui Folded        #263        #ed             b
    HiGui FoldColumn    #6          #c
    HiGui IncSearch     fg          bg              r
    HiGui LineNr        #0          #faf0f0
    HiGui ModeMsg       fg          bg              b
    HiGui NonText       #00f        bg              b
    HiGui Search        #0          #0ff
    HiGui SpecialKey    #00f        bg
    HiGui StatusLine    fg          bg              r
    HiGui StatusLineNC  #6          #c
    HiGui Title         #f0f        bg              b
    HiGui Question      #2e8b57     bg              b
    HiGui MatchParen    fg          #aff            b

    " This seems to be buggy, so we don't use it.
    "highlight CursorIM

    " Depending on the specified options, we'll show either harsh or soft
    " error/warning messages.
    if s:soft_errorMsg == 1
        HiGui ErrorMsg      #0      #ff0
    else
        HiGui ErrorMsg      #fff    #f00
    endif
    if s:soft_warningMsg == 1
        HiGui WarningMsg    #0      #ff0
    else
        HiGui WarningMsg    #f00    bg
    endif


    " Often used syntax highlight groups: {{{3
    HiGui Error         #f          #f00
    HiGui Special       #f0f        bg
    HiGui SpecialChar   #a020f0     #f8f8ff
    HiGui Comment       #307040     bg
    HiGui Number        #f00        bg
    HiGui Constant      #f00        bg
    HiGui Define        #008080     #f8fff8
    HiGui PreProc       #008080     #f8fff8

    HiGui Statement     #a11        bg
    HiGui Type          #201080     bg
    HiGui Todo          #00f        #ff0
    HiGui Identifier    #0          bg              b
    "HiGui Identifier    #000080     bg              b
    HiGui Underlined    #6a5acd     bg              u
    if s:ignore_invisible == 1
        HiGui Ignore        bg          bg
    else
        HiGui Ignore        #c          bg
    endif
    HiGui String        #40         #f5
    HiGui Character     #f00        #f5


    " Less frequently used syntax highlighting groups: {{{3
    HiGui Tag               #008000     bg
    HiGui Subtitle          #009        bg              b
    HiGui Function          #1040d0     bg
    HiGui Conditional       #f11        bg
    HiGui Keyword           #005        #eef
    HiGui Macro             #005599     #f3ffff
    HiGui Typedef           #008080     #f8fff8
    HiGui Delimiter         #0          #ffd            b
    HiGui SpecialComment    #307040     #fffffa         b


    " Extra highlighting groups. {{{3
    " NOTE: When you use these in a syntax file, you should also provide links
    " to default groups for them. This will ensure the syntax file works with
    " other colorschemes too.
    HiGui SpecialCommentNotes   #f0f        bg
    HiGui SpecialComment1       #307040     #f0f0f0     b
    HiGui SpecialComment2       #307040     #f5f5f5     b
    HiGui Fade                  #c          bg
    " }}}2
else
    " Soft Colors {{{2
    " Non-Syntax highlight groups: {{{3
    HiGui Normal        #0          #d
    HiGui Cursor        bg          fg
    HiGui SignColumn    #000080     #c0
    HiGui Visual        #0          #ee9
    HiGui VisualNOS     fg          bg              b,u
    HiGui DiffAdd       fg          #c0cae6
    HiGui DiffChange    fg          #e2c8e2
    HiGui DiffDelete    #66c        #bbe2dd         b
    HiGui DiffText      fg          #e99            b
    HiGui Folded        #457050     #e6             b
    HiGui FoldColumn    #6          #c
    HiGui IncSearch     #c          #677
    HiGui LineNr        #6          #e6
    HiGui ModeMsg       fg          bg              b
    HiGui NonText       #33e        bg              b
    HiGui SpecialKey    #33e        bg
    HiGui Search        #0          #9df
    HiGui StatusLine    #6          bg              r
    HiGui StatusLineNC  #6          #c
    HiGui Title         #b5b        bg              b
    HiGui Question      #2e8b57     bg              b
    HiGui MatchParen    #c33        bg              b

    " This seems to be buggy, so we don't use it.
    "highlight CursorIM

    " Depending on the specified options, we'll show either harsh or soft
    " error/warning messages.
    if s:soft_errorMsg == 1
        HiGui ErrorMsg      #0      #dd6
    else
        HiGui ErrorMsg      #f      #d66
    endif
    if s:soft_warningMsg == 1
        HiGui WarningMsg    #0      #dd6
    else
        HiGui WarningMsg    #f      #d66
    endif


    " Often used syntax highlight groups: {{{3
    HiGui Error         #f          #d66
    HiGui Special       #b5b        bg
    HiGui SpecialChar   #a4a        #dde
    HiGui Comment       #457050     bg
    HiGui Number        #d33        bg
    HiGui Constant      #d33        bg
    HiGui Define        #226960     #dcdedc
    HiGui PreProc       #226960     bg
    HiGui Statement     #622        bg
    HiGui Type          #201080     bg
    HiGui Todo          #4          #ee4
    HiGui Identifier    #3          bg              b
    "HiGui Identifier    #28286b     bg              b
    HiGui Underlined    #6a5acd     bg              u
    if s:ignore_invisible == 1
        HiGui Ignore        bg          bg
    else
        HiGui Ignore        #b          bg
    endif
    HiGui String        #5          #e3
    HiGui Character     #d33        #e3


    " Less frequently used syntax highlighting groups: {{{3
    HiGui Tag               #008000     bg
    HiGui Subtitle          #339        bg              b
    HiGui Function          #249        bg
    HiGui Conditional       #b33        bg
    HiGui Keyword           #005        #d0
    HiGui Macro             #446d75     #d9dcdf
    HiGui Typedef           #226960     #dcdedc
    HiGui Delimiter         #3          #e0e0cc     b
    HiGui SpecialComment    #457050     #d6         b


    " Extra highlighting groups. {{{3
    " NOTE: When you use these in a syntax file, you should also provide links
    " to default groups for them. This will ensure the syntax file works with
    " other colorschemes too.
    HiGui SpecialCommentNotes   #b5b        bg
    HiGui SpecialComment1       #457050     #eaeadf     b
    HiGui SpecialComment2       #457050     #e0e0d5     b
    HiGui Fade                  #b          bg
    " }}}2
endif

if s:harsh_colors == -1
    " Printable (extends Soft colors) {{{2
    HiGui Normal        #0          #f
    HiGui Folded        #263        #ed             b
    HiGui FoldColumn    #6          #d6
    HiGui LineNr        #6          #f0

    HiGui SpecialChar   #a4a        bg
    HiGui String        #5          #f6
    HiGui Character     #d33        #f3

    HiGui Delimiter         #3          #f
    HiGui SpecialComment    #457050     #f3         b
    " }}}2
endif


" Link those with same color together. {{{2
highlight link Float        Number
highlight link WildMenu     Visual
highlight link Directory    SpecialKey
highlight link VertSplit    StatusLine
highlight link MoreMsg      Question

highlight link Debug        Exception
highlight link StorageClass Type
highlight link Label        Conditional
highlight link Repeat       Conditional
highlight link Structure    Type
highlight link Exception    Statement
highlight link Operator     Statement
highlight link PreCondit    PreProc
highlight link Include      PreProc
highlight link Boolean      Number

" MBENormal               - for buffers that have NOT CHANGED and
"                           are NOT VISIBLE.
" MBEChanged              - for buffers that HAVE CHANGED and are
"                           NOT VISIBLE
" MBEVisibleNormal        - buffers that have NOT CHANGED and are
"                           VISIBLE
" MBEVisibleActive        - buffers that have NOT CHANGED and are
"                           VISIBLE and is the active buffer
" MBEVisibleChanged       - for buffers that have CHANGED and are
"                           VISIBLE
" MBEVisibleChangedActive - buffers that have CHANGED and are VISIBLE
"                           and is the active buffer
highlight link MBENormal               String
highlight link MBEChanged              Identifier
highlight link MBEVisibleNormal        Tag
highlight link MBEVisibleActive        Statement
highlight link MBEVisibleChanged       Identifier
highlight link MBEVisibleChangedActive Character

" }}}1


" TODO: redo!
" Terminal coloring {{{1
"" vim {{{2
"highlight Visual       term=reverse    ctermfg=Yellow      ctermbg=Red
"highlight Search       term=reverse    ctermfg=Black       ctermbg=Cyan
"highlight Tag          term=bold       ctermfg=DarkGreen
"highlight StatusLine   term=bold,reverse
"highlight StatusLine   cterm=NONE      ctermfg=Yellow      ctermbg=DarkGray
"highlight Error        term=reverse    ctermfg=15          ctermbg=9
"
"" Syntax {{{2
"highlight Comment      term=bold       ctermfg=Red
"highlight Constant     term=underline  ctermfg=Magenta
"highlight Special      term=bold       ctermfg=Magenta
"highlight SpecialChar  term=bold       ctermfg=Magenta
"highlight Identifier   term=underline  ctermfg=Blue
"highlight Statement    term=bold       ctermfg=DarkRed
"highlight PreProc      term=underline  ctermfg=Magenta
"highlight Type         term=underline  ctermfg=Blue
"highlight Todo         term=standout   ctermbg=Yellow      ctermfg=Black
" }}}1


" Finishing steps {{{2
" Delete the temporary commands.
delcommand HiGui
delcommand InitOption
" }}}1


" vim:set ts=4 sw=4 tw=99 fdm=marker fdl=1 fdc=3:
