syntax keyword cType	Char Uchar Int Uint Llong Ullong Doub Ldoub Complex Bool

" Hide the fold marks.
syntax match	cFoldMarks		contained "{\{3}\d*$\|}\{3}\d*$"
syntax match	cFoldMarks		contained "^//\s*}\{3}\d*$"
syntax match	cFoldMarks		contained "\s\@<=//\s*}\{3}\d*$"
syntax cluster	cCommentGroup	add=cFoldMarks

" Make the lines with an opening fold highlighted differently. The order in
" which we add these syntax items is important, as the last one matching is
" preferred.
syntax match	cFoldOpen3		contained "//.*\(\s{\{3}[3-9]\?$\)\@="
syntax match	cFoldOpen1		contained "//.*\(\s{\{3}1$\)\@="
syntax match	cFoldOpen2		contained "//.*\(\s{\{3}2$\)\@="
syntax cluster	cCommentGroup	add=cFoldOpen1,cFoldOpen2,cFoldOpen3

" Important lines are marked with an "<" at their end.
syntax match	cImportant		contained "//.*\(\s<$\)\@="
syntax cluster	cCommentGroup	add=cImportant
" Hide the "<" mark.
syntax match	cFoldMarks		contained "\s<$"

" Doxygen markup
syntax match	cDoxBriefMarker	contained "\\brief"
syntax match	cDoxBrief		contained "\(//! \\brief  \)\@<=.*"
syntax match	cDoxBrief		contained "\(//!         \)\@<=\S.*"
syntax match	cDoxBrief		contained "\(//!< \)\@<=.*"
syntax match	cDoxBrief		contained "\(/*! \\brief  \)\@<=.*\( \*/$\)\@="
syntax cluster	cCommentGroup	add=cDoxBrief,cDoxBriefMarker

" Comment notes.
syntax match	cNotes			contained "NOTE:\s\+"
syntax cluster	cCommentGroup	add=cNotes

" My member vars start with a lower case "f", followed by an upper case char.
syntax match	cMyMemberVar	"\<f[A-Z]\w*\>"

" Maya enum constants often begin with a "k", followed by an upper case char.
syntax match	cMConstant		"\<k[A-Z]\w*\>"


" Create a temporary command to only set unlinked groups when possible.
if version < 508
	command -nargs=+ HiLink hi link <args>
else
	command -nargs=+ HiLink hi def link <args>
endif

HiLink cFoldMarks		Fade
HiLink cNotes			SpecialCommentNotes
HiLink cFoldOpen2		SpecialComment2
HiLink cFoldOpen1		SpecialComment1
HiLink cDoxBrief		SpecialComment1
HiLink cDoxBriefMarker	Fade


" Since the above groups aren't known to most colorschemes, we'll link them to
" default groups.
HiLink SpecialComment1		SpecialComment
HiLink SpecialComment2		SpecialComment
HiLink SpecialCommentNotes	Special
HiLink Fade					Ignore


" Link some items to default, but seldomly used groups.
HiLink cImportant		SpecialComment
HiLink cFoldOpen3		SpecialComment
HiLink cMConstant		SpecialChar
HiLink cMyMemberVar		Delimiter


" To ensure most colorschemes show a highlighting for them, we'll link
" those groups to more frequently used items to, just in case they don't
" have a highlighting in the current color file.
HiLink Delimiter		Identifier
"HiLink Macro			Define
"HiLink Typedef			Define
"HiLink Debug			Exception
"HiLink Label			Conditional
"HiLink Repeat			Conditional
"HiLink Structure		Type
"HiLink StorageClass		Type
"HiLink Function			Statement
"HiLink Keyword			Statement
"HiLink Exception		Statement
"HiLink Operator			Statement
"HiLink Define			PreProc
"HiLink PreCondit		PreProc
"HiLink Include			PreProc
"HiLink Conditional		Constant
"HiLink Boolean			Number
"HiLink Float			Number
HiLink SpecialChar		Special
HiLink SpecialComment	Comment


" Delete the temporary command
delcommand HiLink
