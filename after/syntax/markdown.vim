syntax match markdownTagsLine /\vTags:.*/ contained containedin=htmlH1
syntax match markdownTagValues /.*$/ contained containedin=markdownTagsLine
syntax match markdownTags /\vTags:/ contained containedin=markdownTagsLine

syntax match markdownCodeIndent /^  \zs \ze / contained containedin=mkdSnippetPYTHON,mkdSnippetSH,pythonString

highlight default link markdownCodeIndent SnippetTabstop
highlight default link markdownTags Title
highlight default link markdownTagValues Constant

highlight link mkdCodeStart Fade
highlight link mkdCodeEnd Fade
