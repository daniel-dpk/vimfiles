" Personal Vim configuration of Daniel Pook-Kolb
" Maintainer: Daniel Pook-Kolb <daniel@dpk.stargrav.com>
" License:    MIT (see LICENSE.txt)


if has('gui_running')
    set encoding=utf-8
endif
scriptencoding utf-8

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

set nocompatible

if has("autocmd")
    filetype plugin indent on
endif

if !has('gui_running')
    let c='a'
    while c <= 'z'
      exec "set <A-".c.">=\e".c
      exec "nmap \e".c." <A-".c.">"
      exec "set <A-".toupper(c).">=\e".toupper(c)
      exec "nmap \e".toupper(c)." <A-".toupper(c).">"
      let c = nr2char(1+char2nr(c))
    endw
    set ttimeout
    set ttimeoutlen=50
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
    else
        let &t_SI = "\e[5 q"
        let &t_EI = "\e[2 q"
    endif
endif


"------------------------------"
"  Pathogen to handle bundles  "
"------------------------------"
" Load Pathogen (https://github.com/tpope/vim-pathogen)
runtime bundle/vim-pathogen/autoload/pathogen.vim

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []
if version < 704 || (!has("python3") && !has("python"))
    call add(g:pathogen_disabled, 'ultisnips')
endif

" This will actually source the scripts
call pathogen#infect()


"----------------"
"  Basic config  "
"----------------"
" This will set the language to default (English) on all systems. Useful e.g.
" to get english error messages when trying to google solutions.
language C

set backspace=indent,eol,start
set autoindent
set history=1000 " keep some lines of command line history
set ruler        " show the cursor position all the time
set showcmd      " display incomplete commands
set incsearch    " do incremental searching
set modeline     " execude modelines
set number       " show line numbers
set scrolloff=4  " always keep 4 lines above/below the cursor
set nowrap       " disable visual-only word wrap at window border
set linebreak    " when word wrap is enabled, keep words together
set nojoinspaces " put just one space between sentences when formatting
set nrformats=   " don't increment octal or hex numbers
set listchars+=precedes:«,extends:»
set previewheight=16
set fillchars=fold:\ ,vert:\|
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set textwidth=78
set formatoptions-=o " I don't like 'o' to insert the comment-leader
set formatoptions+=l " don't break already long lines
set formatoptions+=r " insert comment leader when hitting <CR>
if version >= 704
    set formatoptions+=j " remove comment characters upon joining (with 'J')
endif
set foldenable
set foldmethod=marker
set foldlevelstart=99
set foldopen+=insert

" Use forward slash when expanding file names, even on Windows.
" NOTE: This conflicts with netrw (as of Vim-7.4), since it'll use the wrong
"       quotes around arguments, making putty fail.
"set shellslash

" Show the statusline even with just one window
set laststatus=2  " 0: never, 1: w/ multiple windows, 2: always

" Allow backspace (b), space (s), and the cursor keys (<>[]) to move to the
" previous/next line.
set whichwrap=b,s,<,>,[,]

" Switch syntax highlighting on, when the terminal has colors. Also switch on
" highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif


" Excluding files when matching
set wildignore+=tags,*~,*/.*/*,*/.hg/*,*/.svn/*
set wildignore+=*.o,*.obj,*.exe,*.so,*.dll,*.pyc,*.pyo,*.pyd
set wildignore+=*.lnk,*.pdf
set wildignore+=*/temp/*,*/publish/*,*/dist/*,*/external_libs/*
set wildignore+=*/debug*/*,*/release*/*,*/Doxygen/*


" Hide buffers even when they have changed (think twice before doing :q!)
set hidden

" When an opened file changes outside Vim, immediately load changes
set autoread

" Configure sessions
" Default: blank,buffers,curdir,folds,help,options,tabpages,winsize
set sessionoptions-=options
set sessionoptions-=localoptions
set sessionoptions-=help
set sessionoptions+=unix
set sessionoptions+=slash
set sessionoptions+=winpos
set sessionoptions+=resize


" Which file to add custom dictionary entries to.
let &spellfile=(split(&runtimepath,',')[0])."/spell/my.".(&encoding).".add"


" Enable undoing of Ctrl-w and Ctrl-u commands in insert mode.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>


" Use stronger encryption
if version >= 744
    set cryptmethod=blowfish2
elseif version >= 703
    set cryptmethod=blowfish
endif


"----------------"
"  Autocommands  "
"----------------"
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        autocmd!

        " Separate colorscheme for Todo lists.
        autocmd BufEnter Todo.txt set background=dark |
                    \ silent! colorscheme darkblue |
                    \ silent! colorscheme oceandeep

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufWinEnter *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe 'normal! g`"zvzz' |
                    \ endif

    augroup END

    augroup QuickFixing
        " this one is which you're most likely to use?
        autocmd QuickFixCmdPost [^l]* nested cwindow
    augroup end

    " Don't use the viminfo file when editing encrypted files.
    augroup SecureEm
        autocmd!
        autocmd BufReadPre,BufRead *
                    \ if strlen(&key) |
                    \   set nobk nowb vi= |
                    \ endif
    augroup END
endif


"---------------------------------"
"  Configure backups, swap, undo  "
"---------------------------------"
" If we use them, save backups to a less annoying place than the current directory.
set backupdir=~/.vim/.backup
set backupdir+=~/vimfiles/.backup
let &backupdir.=','.(split(&runtimepath,',')[0])."/.backup"
set backupdir+=. " as a last resort

" If we use them, save swap files to a less annoying place than the current directory.
" The double-slashes indicate that filenames should contain the path.
set directory=~/.vim/.swap//
set directory+=~/vimfiles/.swap//
let &directory.=','.(split(&runtimepath,',')[0])."/.swap//"
if has("win32")
    set directory+=c:/tmp//,c:/temp//
else
    set directory+=~/tmp//,~/temp//,/tmp//
endif
set directory+=. " as a last resort

" Configure persistent undo
if v:version >= 703
    set undodir=~/.vim/.undo
    set undodir+=~/vimfiles/.undo
    let &undodir.=','.(split(&runtimepath,',')[0])."/.undo"
    set undodir+=.
    set undofile
endif


"----------------"
"  Colorschemes  "
"----------------"
if has('gui_running')
    set background=dark
    silent! colorscheme desert " fallback if the below scheme doesn't exist
    silent! colorscheme hybrid
    "let g:dpk_harsh_colors = 0
    "color DPK_colors
else
    set background=dark
    colorscheme desert
endif


"----------------"
"  Key Mappings  "
"----------------"
" Change the local leader (for filetype key mappings) to ",".
let maplocalleader = ","

" On German keyboards CTRL-] doesn't work, since the "]" key is CTRL-ALT-9.
" I'll use ALT-SHIFT-i to do the "jump".
map <A-S-I> <C-]>
map g<A-S-I> g<C-]>


" Delete without replacing yanked text (can be combined with motions, etc.).
nnoremap <silent> <LocalLeader>d "_d
vnoremap <silent> <LocalLeader>d "_d


" Use "\v" to search for a regexp in the current directory.
nnoremap <Leader>v :vimgrep // <C-r>=<SID>DPK_grepFileMatcher(1)<CR><Home><S-Right><Right><Right>
function! s:DPK_grepFileMatcher(extended)
    let l:matchStr = fnamemodify(expand("%"),":e")
    if a:extended && l:matchStr ==? "cpp" || l:matchStr ==? "h"
        let l:matchStr = "**/*.cpp **/*.h"
    else
        let l:matchStr = "**/*." . l:matchStr
    endif
    return l:matchStr
endfunction

" Quickly jump between matches (i.e. in the error list)
nnoremap <LocalLeader>n :cn<CR>zv
nnoremap <LocalLeader>N :cnf<CR>zv
nnoremap <LocalLeader>p :cp<CR>zv
nnoremap <LocalLeader>P :cpf<CR>zv


" Make F4 toggle spell checking (for Vim 7 and above).
if has("spell")
    nmap <F4> <ESC>:set spell!<CR>
    imap <F4> <ESC>:set spell!<CR>a
endif


" Mappings for split windows.
nmap <silent> <A-S-h> <C-W>h
nmap <silent> <A-S-l> <C-W>l
nmap <silent> <A-S-j> <C-W>j
nmap <silent> <A-S-k> <C-W>k

" For Vim 7, we'll move between tabs using CTRL-Arrows.
if v:version >= 700
    map <C-Left>  <ESC>:tabprev<CR>
    map <C-Right> <ESC>:tabnext<CR>
    map <C-S-Left>  <ESC>:tabmove -1<CR>
    map <C-S-Right> <ESC>:tabmove +1<CR>
    nnoremap <silent> tt :tab split<CR>
    nnoremap <silent> TT :tabclose<CR>
endif

" In insert mode, we want the <HOME> key to move the cursor to the start of
" the text (first non whitespace). To go to the first column, press 0 in
" normal mode or use the h or cursor key.
imap <HOME> <ESC>I

" Change to the directory of the currently edited file.
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Set fileformat to unix.
nnoremap <Leader><Leader>u :set ff=unix<CR>:set ff?<CR>


" Evaluating math expressions using perl
if has("win32")
    " Evaluate an expression contained on the full current line and place answer
    " in a new line below the current line:
    nnoremap <Leader>ma yyp^y$V:!perl -e "$pi = 4*atan2(1,1);sub fact{$_[0]&&$_[0]>=1?$_[0]*fact($_[0]-1):1} $x = <C-R>"; print $x"<CR>-y0j0P
    " Evaluate an expression contained in a visual selection and place the answer
    " in a new line below the current line:
    vnoremap <Leader>ma yo<Esc>p^y$V:!perl -e "$pi = 4*atan2(1,1);sub fact{$_[0]&&$_[0]>=1?$_[0]*fact($_[0]-1):1} $x = <C-R>"; print $x"<CR>-y0j0P
    " Evaluate an expression contained on the full current line and replace the
    " current line with the answer:
    nnoremap <Leader>mr ^"gy0^y$V:!perl -e "$pi = 4*atan2(1,1);sub fact{$_[0]&&$_[0]>=1?$_[0]*fact($_[0]-1):1} $x = <C-R>"; print $x"<CR>^"gP
    " Evaluate an expression contained in a visual selection and replace the
    " visual selection with the answer:
    vnoremap <Leader>mr "aygvrXgv"by:r !perl -e "$pi = 4*atan2(1,1);sub fact{$_[0]&&$_[0]>=1?$_[0]*fact($_[0]-1):1} $x = <C-R>a; print $x"<CR>0"cyWddk:s/<C-R>b/<C-R>c/<CR>
else
    nnoremap <Leader>ma yyp^y$V:!perl -e "\$pi = 4*atan2(1,1);sub fact{\$_[0]&&\$_[0]>=1?\$_[0]*fact(\$_[0]-1):1} \$x = <C-R>"; print \$x"<CR>-y0j0P
    vnoremap <Leader>ma yo<Esc>p^y$V:!perl -e "\$pi = 4*atan2(1,1);sub fact{\$_[0]&&\$_[0]>=1?\$_[0]*fact(\$_[0]-1):1} \$x = <C-R>"; print \$x"<CR>-y0j0P
    nnoremap <Leader>mr ^"gy0^y$V:!perl -e "\$pi = 4*atan2(1,1);sub fact{\$_[0]&&\$_[0]>=1?\$_[0]*fact(\$_[0]-1):1} \$x = <C-R>"; print \$x"<CR>^"gP
    vnoremap <Leader>mr "aygvrXgv"by:r !perl -e "\$pi = 4*atan2(1,1);sub fact{\$_[0]&&\$_[0]>=1?\$_[0]*fact(\$_[0]-1):1} \$x = <C-R>a; print \$x"<CR>0"cyWddk:s/<C-R>b/<C-R>c/<CR>
endif


"----------------------"
"  Configure Plug-Ins  "
"----------------------"

" UltiSnips (https://github.com/SirVer/ultisnips) {{{1
" Needed for default snippets: https://github.com/honza/vim-snippets
if version >= 704 && has("python3") || has("python")
    nnoremap <Leader>se :UltiSnipsEdit<CR>
    let g:UltiSnipsEditSplit           = "horizontal"
    let g:UltiSnipsExpandTrigger       = "<c-j>"
    let g:UltiSnipsListSnippets        = "<c-tab>"
    let g:UltiSnipsJumpForwardTrigger  = "<c-j>"
    let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
endif

" Put these two into ~/.vimrc or ~/vimfiles/custom_settings.vim
"let g:snips_author = "Your Name"
"let g:snips_email  = "your@email"


" fugitive (Vim Git wrapper) (https://github.com/tpope/vim-fugitive) {{{1
" Start external gitk, since fugitive doesn't have an equivalent.
if has("win32")
    command! Gitk        silent !start gitk --all
    command! Gitgui      silent !start git-gui
    command! Gitterminal silent !start /min git_shell.bat
else
    command! Gitk   silent !gitk --all&
    command! Gitgui silent !git gui&
    command! Gitterminal silent !x-terminal-emulator
endif

nnoremap <c-c> <Nop>
nnoremap <c-g><c-s> :Gstatus<CR>
nnoremap <c-g><c-c> :Gcommit<CR>
nnoremap <silent> <c-g><c-k> :Gitk<CR>:redraw!<CR>
nnoremap <silent> <c-g><c-g> :Gitgui<CR>:redraw!<CR>

nnoremap <c-g><c-t> :Gitterminal<CR>
if has("win32")
    nnoremap <silent> <c-g><c-e> :silent !start /min cmd /C start .<CR>
endif

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P


" CtrlP (https://github.com/ctrlpvim/ctrlp.vim) {{{1
nnoremap <silent> <a-p> :CtrlPBuffer<CR>

let g:ctrlp_working_path_mode = ''
let g:ctrlp_switch_buffer = 0
let g:ctrlp_show_hidden = 1 " show dotfiles by default


" NERDTree (https://github.com/scrooloose/nerdtree) {{{1
nmap <silent> <F12>   :NERDTreeToggle<CR>
nmap <silent> <C-F12> :NERDTreeMirror<CR>
nmap <silent> <S-F12> :NERDTreeFind<CR>
let NERDTreeIgnore=['\~$','^_[[dir]]','\.py[co]$','^tags$','^dist$[[dir]]']
let NERDTreeMinimalUI=1
if has('gui_running')
    let NERDTreeDirArrows=1
else
    let NERDTreeDirArrows=0
endif

function NERDTreeMyOpenFile(node)
    call a:node.activate({'reuse': 'currenttab', 'where': 'p'})
endfunction
autocmd VimEnter * :call
            \ NERDTreeAddKeyMap({'key': 'o', 'callback': 'NERDTreeMyOpenFile',
            \                    'scope': 'FileNode', 'override': 1 })


" Localvimrc (https://github.com/embear/vim-localvimrc) {{{1
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 1
let g:localvimrc_persistent = 1


" vim-session (https://github.com/xolox/vim-session) {{{1
" Requires: https://github.com/xolox/vim-misc
let g:session_autoload = 'no'
let g:session_autosave = 'yes'


" vim-css-color (https://github.com/skammer/vim-css-color) {{{1
let g:cssColorVimDoNotMessMyUpdatetime = 1


" Tabular (https://github.com/godlygeek/tabular) {{{1
nmap <LocalLeader>a=           mm:Tabularize /==\?>\?<CR>`m
vmap <LocalLeader>a=           mm:Tabularize /==\?>\?<CR>`m
nmap <LocalLeader>a>           mm:Tabularize /=><CR>`m
vmap <LocalLeader>a>           mm:Tabularize /=><CR>`m
nmap <LocalLeader>a:           mm:Tabularize /:\zs/l0l1<CR>`m
vmap <LocalLeader>a:           mm:Tabularize /:\zs/l0l1<CR>`m
nmap <LocalLeader>a;           mm:Tabularize /;\zs/l0l1<CR>`m
vmap <LocalLeader>a;           mm:Tabularize /;\zs/l0l1<CR>`m
nmap <LocalLeader>a"           mm:Tabularize /^[^"]*\zs"/l1l0<CR>`m
vmap <LocalLeader>a"           mm:Tabularize /^[^"]*\zs"/l1l0<CR>`m
nmap <LocalLeader>A"           mm:Tabularize /^[^"]*\zs"/l1l1<CR>`m
vmap <LocalLeader>A"           mm:Tabularize /^[^"]*\zs"/l1l1<CR>`m
nmap <LocalLeader>a,           mm:Tabularize /,\zs/l0l1<CR>`m
vmap <LocalLeader>a,           mm:Tabularize /,\zs/l0l1<CR>`m
nmap <LocalLeader>a{           mm:Tabularize /{<CR>`m
vmap <LocalLeader>a{           mm:Tabularize /{<CR>`m
nmap <LocalLeader>a(           mm:Tabularize /(\zs/l0<CR>`m
vmap <LocalLeader>a(           mm:Tabularize /(\zs/l0<CR>`m
nmap <LocalLeader>a/           mm:Tabularize /\/\/.*<CR>`m
vmap <LocalLeader>a/           mm:Tabularize /\/\/.*<CR>`m
nmap <LocalLeader>a\           mm:Tabularize /\\$<CR>`m
vmap <LocalLeader>a\           mm:Tabularize /\\$<CR>`m
nmap <LocalLeader>a#           mm:Tabularize /#.*<CR>`m
vmap <LocalLeader>a#           mm:Tabularize /#.*<CR>`m
nmap <LocalLeader>a<Space>     mm:Tabularize /^\s*[^\/ \t]\S\+\zs\s/l0l0<CR>`m
vmap <LocalLeader>a<Space>     mm:Tabularize /^\s*[^\/ \t]\S\+\zs\s/l0l0<CR>`m
nmap <LocalLeader>a<S-Space>   mm:Tabularize /^\s*[^\/ \t].\{-}\zs\s\S\+\( = \S\+\)\?\()[^)]*\)\?$/l0<CR>`m
vmap <LocalLeader>a<S-Space>   mm:Tabularize /^\s*[^\/ \t].\{-}\zs\s\S\+\( = \S\+\)\?\()[^)]*\)\?$/l0<CR>`m
nmap <LocalLeader>a<C-Space>   mm:Tabularize /^\s*[^\/ \t]\S\+\s\+\S\+\zs\s/l0l0<CR>`m
vmap <LocalLeader>a<C-Space>   mm:Tabularize /^\s*[^\/ \t]\S\+\s\+\S\+\zs\s/l0l0<CR>`m
nmap <LocalLeader>a<C-S-Space> mm:Tabularize /\S\zs /l0l1<CR>`m
vmap <LocalLeader>a<C-S-Space> mm:Tabularize /\S\zs /l0l1<CR>`m
nmap <LocalLeader>a&           mm:Tabularize /&<CR>`m
vmap <LocalLeader>a&           mm:Tabularize /&<CR>`m


" clang-format {{{1
if has("win32")
    map <C-K> :pyf ~/Apps/clang-format/clang-format.py<cr>
    imap <C-K> <c-o>:pyf ~/Apps/clang-format/clang-format.py<cr>
else
    map <C-K> :py3f /usr/share/vim/addons/syntax/clang-format.py<cr>
    imap <C-K> <c-o>:py3f /usr/share/vim/addons/syntax/clang-format.py<cr>
endif


" syntastic {{{1
nnoremap <Leader>sc :SyntasticCheck<CR>
nnoremap <Leader>sl :Errors<CR>
nnoremap <Leader>sr :SyntasticReset<CR>
nnoremap <Leader>st :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_cursor_column = 0    " speed up on large lists of errors
let g:syntastic_enable_highlighting = 0

" Don't run automatically; wait for a :SyntasticCheck
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": [] }


" vim-gnupg (https://github.com/jamessan/vim-gnupg) {{{1
let g:GPGUseAgent = 0
let g:GPGUsePipes = 1


" Load custom settings (if any) {{{1
runtime custom_settings.vim

" }}}1


" vim:set ts=4 sw=4 sts=4 et tw=78 fdm=marker:
