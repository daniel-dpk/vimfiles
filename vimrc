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
    set ttimeoutlen=0
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
call add(g:pathogen_disabled, 'syntastic')
"call add(g:pathogen_disabled, 'ale')

" This old plugin seems to make Markdown files load excessively slow
call add(g:pathogen_disabled, 'vim-css-color')

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


function! CustomFoldText()
    let line = substitute(foldtext(), '.\{-}: ', "", "")
    let indent = repeat(' ', indent(v:foldstart))
    let numLines = v:foldend - v:foldstart + 1
    return indent . line . ' [+' . v:folddashes . ' ' . numLines . ' lines]'
endfunction
set foldtext=CustomFoldText()
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

" Disable beep and flashing
set noerrorbells
set visualbell
set t_vb=


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


" Make ,s toggle spell checking (for Vim 7 and above).
if has("spell")
    nmap <LocalLeader>s <ESC>:set spell!<CR>
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
    map <S-Left>  <ESC>:tabmove -1<CR>
    map <S-Right> <ESC>:tabmove +1<CR>
    nnoremap <silent> tt :tab split<CR>
    " Close current tab leaving us on previous tab (instead of next).
    nnoremap <silent> TT :silent! tabmove -1<CR>:tabclose<CR>
endif

" In insert mode, we want the <HOME> key to move the cursor to the start of
" the text (first non whitespace). To go to the first column, press 0 in
" normal mode or use the h or cursor key.
imap <HOME> <ESC>I

" Change to the directory of the currently edited file.
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Set fileformat to unix.
nnoremap <Leader><Leader>u :set ff=unix<CR>:set ff?<CR>


" Credit: xolox on Stack Overflow (https://stackoverflow.com/a/6271254)
function! s:get_visual_selection(concat)
    let [line1, col1] = getpos("'<")[1:2]
    let [line2, col2] = getpos("'>")[1:2]
    let lines = getline(line1, line2)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    if a:concat
        return join(lines, "")
    endif
    return join(lines, "\n")
endfunction

function! Py3Calculate(expr, trim)
    let result = system("python3 -c \"from math import *; print(".a:expr.")\"")
    if a:trim
        let result = substitute(result, '\n$', '', '')
    endif
    return result
endfunction

nnoremap <Leader>ma "=Py3Calculate(getline('.'), 0)<CR>p
vnoremap <Leader>ma <Esc>"=Py3Calculate(<SID>get_visual_selection(1), 0)<CR>p
nnoremap <Leader>mr ^c$<C-R>=Py3Calculate("<C-R>"", 1)<CR><Esc>
vnoremap <Leader>mr c<C-R>=Py3Calculate("<C-R>"", 1)<CR><Esc>


" Search across line breaks using
"   :S Hello World
" Credit: Bryan Ward on Stack Exchange (https://unix.stackexchange.com/a/11848)
function! SearchMultiLine(bang, ...)
    if a:0 > 0
        let sep = (a:bang) ? '\_W\+' : '\_s\+'
        let @/ = join(a:000, sep)
    endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>


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

function! NERDTreeMyOpenFile(node)
    call a:node.activate({'reuse': 'currenttab', 'where': 'p', 'keepopen':!nerdtree#closeTreeOnOpen()})
endfunction
autocmd VimEnter * :call
            \ NERDTreeAddKeyMap({'key': 'o', 'callback': 'NERDTreeMyOpenFile',
            \                    'scope': 'FileNode', 'override': 1 })
autocmd VimEnter * :call
            \ NERDTreeAddKeyMap({'key': '<CR>', 'callback': 'NERDTreeMyOpenFile',
            \                    'scope': 'FileNode', 'override': 1 })


" Localvimrc (https://github.com/embear/vim-localvimrc) {{{1
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 1
let g:localvimrc_persistent = 1


" vim-session (https://github.com/xolox/vim-session) {{{1
" Requires: https://github.com/xolox/vim-misc
let g:session_autoload = 'no'
let g:session_autosave = 'yes'


" maximizer (https://github.com/szw/vim-maximizer) {{{1
let g:maximizer_set_default_mapping = 0
nnoremap <silent> <LocalLeader>z :MaximizerToggle!<CR>


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
nmap <LocalLeader>a%           mm:Tabularize /%<CR>`m
vmap <LocalLeader>a%           mm:Tabularize /%<CR>`m


" clang-format {{{1
if has("win32")
    map <C-K> :pyf ~/Apps/clang-format/clang-format.py<cr>
    imap <C-K> <c-o>:pyf ~/Apps/clang-format/clang-format.py<cr>
else
    map <C-K> :py3f /usr/share/vim/addons/syntax/clang-format.py<cr>
    imap <C-K> <c-o>:py3f /usr/share/vim/addons/syntax/clang-format.py<cr>
endif


" syntastic {{{1
"nnoremap <Leader>sc :SyntasticCheck<CR>
"nnoremap <Leader>sl :Errors<CR>
"nnoremap <Leader>sr :SyntasticReset<CR>
"nnoremap <Leader>st :SyntasticToggleMode<CR>
"
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

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


" ALE (Asynchronous Lint Engine) (https://github.com/dense-analysis/ale) {{{1
"
" The below configuration of ALE disables it by default. You can press '\ale'
" (without quote marks) to activate/deactivate in normal mode. Also, it is
" currently only active for Python and only uses 'pylint'.

nnoremap <silent> <Leader>ale :ALEToggle<CR>

"let g:ale_sign_column_always = 0
let g:ale_disable_lsp = 1
let g:ale_enabled = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1
"let g:ale_linters = {}
let g:ale_linters = {'python': ['pylint']}

function! LinterStatus() abort
    if !g:ale_enabled | return '' | endif
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf(
                \   '  %dW %dE ', all_non_errors, all_errors
                \)
endfunction

function! LinterStatusOK() abort
    if !g:ale_enabled | return '' | endif
    return ale#statusline#Count(bufnr('')).total == 0 ? '  OK ' : ''
endfunction

set statusline+=%{g:ale_enabled?'\ ':''}
set statusline+=%#DiffAdd#%{LinterStatusOK()}
set statusline+=%#warningmsg#%{LinterStatus()}
set statusline+=%*


" vim-gnupg (https://github.com/jamessan/vim-gnupg) {{{1
let g:GPGUseAgent = 0
let g:GPGUsePipes = 1


" Load custom settings (if any) {{{1
runtime custom_settings.vim

" }}}1


" vim:set ts=4 sw=4 sts=4 et tw=78 fdm=marker:
