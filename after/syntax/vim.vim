syn case match

syntax match	vimVarArg		"\<[a]:[0-9]\+\>"

" Hide the fold marks.
syntax match	vimFoldMarks	contained "{\{3}\d*$\|}\{3}\d*$"
syntax match	vimFoldMarks	contained "^\"\s*}\{3}\d*$"
syntax match	vimFoldMarks	contained "\s\@<=\"\s*}\{3}\d*$"
syntax cluster	vimCommentGroup	add=vimFoldMarks

" Make the lines with an opening fold highlighted differently. The order in
" which we add these syntax items is important, as the last one matching is
" preferred.
syntax match	vimFoldOpen3	contained "\".*\(\s{\{3}[3-9]\?$\)\@="
syntax match	vimFoldOpen1	contained "\".*\(\s{\{3}1$\)\@="
syntax match	vimFoldOpen2	contained "\".*\(\s{\{3}2$\)\@="
syntax cluster	vimCommentGroup	add=vimFoldOpen1,vimFoldOpen2,vimFoldOpen3

" Important lines are marked with an "<" at their end.
syntax match	vimImportant	contained "\".*\(\s<$\)\@="
syntax cluster	vimCommentGroup	add=vimImportant
" Hide the "<" mark.
syntax match	vimFoldMarks	contained "\s<$"

" Comment notes.
syntax match	vimNotes		contained "NOTE:\s\+"
syntax cluster	vimCommentGroup	add=vimNotes


" Create a temporary command to only set unlinked groups when possible.
if version < 508
	command -nargs=+ HiLink hi link <args>
else
	command -nargs=+ HiLink hi def link <args>
endif

HiLink vimNotes			SpecialCommentNotes
HiLink vimFoldOpen2		SpecialComment2
HiLink vimFoldOpen1		SpecialComment1
HiLink vimFoldMarks		Fade


" Since the above groups aren't known to most colorschemes, we'll link them to
" default groups.
HiLink SpecialComment1		SpecialComment
HiLink SpecialComment2		SpecialComment
HiLink SpecialCommentNotes	Special
HiLink Fade					Ignore


" Link some items to default, but seldomly used groups.
HiLink vimFoldOpen3		SpecialComment
HiLink vimImportant		SpecialComment
HiLink vimDPK_func		Define
HiLink vimDPKcmd		Macro


" To ensure most colorschemes show a highlighting for them, we'll link
" those groups to more frequently used items to, just in case they don't
" have a highlighting in the current color file.
HiLink Macro			Define
HiLink Define			PreProc
HiLink SpecialComment	Comment


" Link the remaining items to the often used syntax groups.
HiLink vimVarArg		Special


" Delete the temporary command
delcommand HiLink
