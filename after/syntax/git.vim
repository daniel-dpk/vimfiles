syntax match    myGitLogLine    "^[\* |\/\\]*[0-9a-f]\{7,}\>\s.*"
syntax match    myGitLogLine    "^[\* |\/\\]*$"
syntax match    myGitHash       contained "\<[0-9a-f]\{7,}\>" containedin=myGitLogLine
syntax match    myGitDate       contained "\<\d\d\d\d-\d\d-\d\d\>" containedin=myGitLogLine
syntax match    myGitGraph      contained "^[\* |\/\\]\+" containedin=myGitLogLine
syntax match    myGitParens     contained "(.*)" containedin=myGitLogLine
syntax match    myGitPointer    contained "(.* -> .*)" containedin=myGitLogLine

"command -nargs=+ HiLink hi def link <args>
command -nargs=+ HiLink hi! link <args>

HiLink myGitHash     Identifier
HiLink myGitDate     Constant
HiLink myGitGraph    Label
HiLink myGitPointer  Special
HiLink myGitParens   Type

delcommand HiLink
