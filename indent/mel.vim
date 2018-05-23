if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" Mel indenting is similar to C indenting.
setlocal cindent
