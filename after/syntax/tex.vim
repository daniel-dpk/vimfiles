" Check spelling in normal text.
syntax spell toplevel

syn case match


" Fixing missing closing brackets with '%stop]' and '%stop}'
if !exists("g:tex_no_error")
    syn region texMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"	end="%stop}"	contains=@texMatchGroup,texError
    syn region texMatcher		matchgroup=Delimiter start="\["				end="]"	end="%stop]"		    contains=@texMatchGroup,texError
else
    syn region texMatcher		matchgroup=Delimiter start="{" skip="\\\\\|\\[{}]"	end="}"	end="%stop}"	contains=@texMatchGroup
    syn region texMatcher		matchgroup=Delimiter start="\["				end="]"	end="%stop]"		    contains=@texMatchGroup
endif

syn match texInputFile  "\\add\(img\)\=\(\[.\{-}\]\)\=\s*{.\{-}}" contains=texStatement,texInputCurlies,texInputFileOpt
syn match  texRefZone   '\\\([Aa]uto\|[Tt]ext\)cite\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite
syn region texRefZone		matchgroup=texStatement start="\\\([Ee]qns\?\|[Ff]ig\|[Ss]ec\|[Tt]ab\|[Aa]p\|[Cc]hap\)ref{"	end="}\|%stopzone\>"	contains=@texRefGroup

" This is a workaround for a bug in LaTeX highlighting in default Vim config
" files. The correct fix would be to remove 'subequations' from 'texBadMath'.
call TexNewMathZone("M","subequations",0)

" Add this AMS-math environment.
call TexNewMathZone("M","align",1)
call TexNewMathZone("M","alignat",1)
call TexNewMathZone("M","gather",1)
call TexNewMathZone("M","multline",1)

syntax region   texTodoBraces   start="\c\%(\\TODO\|\\\)\@<!{" skip="\\\\\|\\[{}]" end="}" transparent contained contains=texTodoBraces
syntax region   texTodoBox      start="^\s*\c\\TODO{" skip="\\\\\|\\[{}]" end="}" end="%stop}" contains=texTodoBraces containedin=ALL
syntax keyword  texTodoBoxTodo  TODO todo  contained containedin=texTodoBox
syntax keyword	texTodo		contained MARK

syntax match	texFoldMarks	contained "{\{3}\d*$\|}\{3}\d*$" containedin=texComment
syntax match	texFoldMarks	contained "^%\s*}\{3}\d*$"       containedin=texComment
syntax match	texFoldMarks	contained "\s\@<=%\s*}\{3}\d*$"  containedin=texComment

" Make the lines with an opening fold highlighted differently. The order in
" which we add these syntax items is important, as the last one matching is
" preferred.
syntax match	texFoldOpen3	contained "%.*\(\s{\{3}[3-9]\?$\)\@=" containedin=texComment
syntax match	texFoldOpen1	contained "%.*\(\s{\{3}1$\)\@="       containedin=texComment
syntax match	texFoldOpen2	contained "%.*\(\s{\{3}2$\)\@="       containedin=texComment

" Important lines are marked with an "<" at their end.
syntax match	texImportant	contained "%.*\(\s<$\)\@=" containedin=texComment
" Hide the "<" mark.
syntax match	texFoldMarks	contained "\s<$"

" Comment notes.
syntax match	texNotes		contained "NOTE:\s\+" containedin=texComment


" Create a temporary command to only set unlinked groups when possible.
if version < 508
	command -nargs=+ HiLink hi link <args>
else
	command -nargs=+ HiLink hi def link <args>
endif

HiLink texMathZoneBox	texMath
HiLink texTodoBox		Delimiter
HiLink texTodoBraces	SpecialComment
HiLink texInnerBraces	Statement
HiLink texTodoBoxTodo	Todo
HiLink texNotes			SpecialCommentNotes
HiLink texFoldOpen2		SpecialComment2
HiLink texFoldOpen1		SpecialComment1
HiLink texFoldMarks		Fade

" Since the above groups aren't known to most colorschemes, we'll link them to
" default groups.
HiLink SpecialComment1		SpecialComment
HiLink SpecialComment2		SpecialComment
HiLink SpecialCommentNotes	Special
HiLink Fade					Ignore

" Link some items to default, but seldomly used groups.
HiLink texFoldOpen3		SpecialComment
HiLink texImportant		SpecialComment

" To ensure most colorschemes show a highlighting for them, we'll link
" those groups to more frequently used items to, just in case they don't
" have a highlighting in the current color file.
HiLink SpecialComment	Comment


" Delete the temporary command
delcommand HiLink
