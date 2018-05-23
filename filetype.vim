if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufNewFile,BufRead *.ma			setfiletype mel
    au! BufNewFile,BufRead *.plt        setfiletype gnuplot

    au! BufNewFile,BufRead .clang-format    setfiletype conf

    au! BufNewFile,BufRead *.vsh        setfiletype c
    au! BufNewFile,BufRead *.fsh        setfiletype c

    au! BufNewFile,BufRead TAG_EDITMSG  setfiletype gitcommit
augroup END
