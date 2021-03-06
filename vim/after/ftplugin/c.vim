augroup filetype_c
    autocmd!
    " --------------------------------- HIGHLIGHTS {{{
    if &background == "dark"
        au FileType c,cpp hi Search ctermbg=NONE ctermfg=105
        au FileType c,cpp hi cPrint ctermfg=158
        au FileType c,cpp hi cString ctermfg=102
        au FileType c,cpp hi cTodo ctermfg=84
    elseif &background == "light"
        au FileType c,cpp hi Search ctermbg=229 ctermfg=NONE
        au FileType c,cpp hi cPrint ctermfg=33
        au FileType c,cpp hi cString ctermfg=147
        au FileType c,cpp hi cTodo ctermfg=205
    endif
    au FileType c,cpp hi link cCharacter cleared
    au FileType c,cpp hi link cComment LineNr
    au FileType c,cpp hi link cCommentL LineNr
    au FileType c,cpp hi link cCommentStart LineNr
    au FileType c,cpp hi link cConditional cleared
    au FileType c,cpp hi link cConstant cleared
    au FileType c,cpp hi link cDefine cleared
    au FileType c,cpp hi link cInclude cleared
    au FileType c,cpp hi link cIncluded cleared
    au FileType c,cpp hi link cNumber cleared
    au FileType c,cpp hi link cOperator cleared
    au FileType c,cpp hi link cRepeat cleared
    au FileType c,cpp hi link cSpecial cleared
    au FileType c,cpp hi link cStatement cleared
    au FileType c,cpp hi link cStorageClass cleared
    au FileType c,cpp hi link cType cleared
    au FileType c,cpp syn match cPrint ".*print.*" contains=cString,cComment,cCommentL
    au FileType c,cpp syn match cPrint ".*ft_put.*fd (.*" contains=cString,cComment,cCommentL
    " }}}
    " --------------------------------- OPTIONS {{{
    au FileType qf setl wrap
    au FileType c,cpp setl showmatch
    au FileType c,cpp setl noexpandtab cindent textwidth=80
    au FileType c,cpp setl path+=$DOTVIM/after/ftplugin/
    au FileType c,cpp,make setl path+=include/**,../include/**,src*/**,../src*/**
    au FileType c,cpp setl foldmethod=marker
    au FileType c,cpp setl foldmarker={{{,}}}

    " Compile
    au FileType c,cpp let b:name = "minishell"
    au FileType c,cpp let b:cc = "gcc"
    au FileType c,cpp let b:cflags = "-Wall -Wextra -Werror -Wconversion -Wsign-conversion"
    au FileType c,cpp let b:sanitizer = "-fsanitize=address,undefined,signed-integer-overflow -g"
    au FileType c,cpp let b:valgrind = "valgrind -q --leak-check=yes --show-leak-kinds=all --track-fds=yes"
    au FileType c,cpp let b:librairies = ""
    " }}}
    " --------------------------------- PLUGINS {{{
    au FileType c,cpp let g:gutentags_enabled = 1
    au FileType c,cpp let b:surround_45 = '("\r");'
    " }}}
    " --------------------------------- MAPPINGS {{{

    "   MAKE

    "   :make sani
    au Filetype c,cpp,make nn <silent><buffer> ms :wa<CR>
                \
                \:exec 'silent !rm -f minishell'<CR>
                \:!clear<CR>
                \:exec 'make -j sani'<CR>:cw<CR>:!./minishell<CR>
    "   :make fclean sani
    au Filetype c,cpp,make nn <silent><buffer> mS :wa<CR>
                \
                \:exec 'silent !rm -f minishell'<CR>
                \:!clear<CR>
                \:exec 'make fclean && make -j sani'<CR>:cw<CR>:!./minishell<CR>
    "   :make all
    au Filetype c,cpp,make nn <silent><buffer> ma :wa<CR>
                \
                \:exec 'silent !rm -f minishell'<CR>
                \:!clear<CR>
                \:exec 'make -j all'<CR>:cw<CR>:!./minishell<CR>
    "   :make fclean all
    au Filetype c,cpp,make nn <silent><buffer> mA :wa<CR>
                \
                \:exec 'silent !rm -f minishell'<CR>
                \:!clear<CR>
                \:exec 'make fclean && make -j all'<CR>:cw<CR>:!./minishell<CR>

    "   COMPILE [& RUN] ALL

    "   valgrind
    au Filetype c nn <silent><buffer> <Space>4 :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;' . b:valgrind . ' ./a.out \|cat -e'<CR>

    "   sanitizer
    au Filetype c nn <silent><buffer> <Space>5 :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' ' . b:sanitizer . ' % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out \|cat -e'<CR>
                " \:exec '!clear;./a.out /bin/ls "\|" /usr/bin/grep microshell ";" /bin/echo hello\|cat -e'<CR>
    "   nothing
    au Filetype c nn <silent><buffer> <Space>% :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc . ' -Wno-everything % ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out \|cat -e'<CR>

    "   COMPILE [& RUN] ALL

    au Filetype c nn <silent><buffer> <Space>8 :wa\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc ' ' . b:cflags . ' ' . b:sanitizer . ' *.c ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>:
                \:exec '!clear;./a.out \|cat -e'<CR>

    au Filetype c nn <silent><buffer> <Space>* :wa\|lc %:h<CR>
                \
                \:exec 'silent !rm -rf a.out a.out.dSYM'<CR>
                \:exec 'silent !' . b:cc . ' -Wno-everything *.c ' . b:librairies . ' 2>/tmp/c_qf_err'<CR>
                \:cfile /tmp/c_qf_err<CR>:5cw<CR>
                \:exec '!clear;./a.out \|cat -e'<CR>

    ""   COMPILE & RUN % & C-Z
    "au Filetype c,cpp nn <silent><buffer> <Space>5 :silent! w \| lc %:h \| se t_ti= t_tr= <CR>
    "            \:silent ! clang -Wall -Wextra -Werror -fsanitize=address %
    "            \ 2>/tmp/c_qf_err<CR>:cfile /tmp/c_qf_err<CR>
    "            \:let cmd=system('./' . b:name . '\|cat -e')<CR>:silent ! rm ' . b:name . ' 2>/dev/null<CR>
    "       \:se t_ti& t_te& \| 3cw \| echom "----["strftime('%H:%M')"]----"<CR>:echom cmd<CR>i<Esc>:echo cmd"\n"<CR>

    "   INDENT FUNCTION
    au Filetype c,cpp nn <silent><buffer> =f mm?^\a<CR>j=%`m:let @/=""<CR>

    "   SEARCH FUNCTIONS
    au Filetype c,cpp nn <silent><buffer> <Space>f /^\a<CR>
    "   LIST FILE FUNCTIONS
    au Filetype c,cpp nn <silent><buffer> <Space>F :keeppatterns g/^\a<CR>

    "   PARENTHESIS AND BRACKETS
    au Filetype c ino <silent><buffer> \<space> ()<Esc>o{<CR>}<Esc>kk$i

    "   FUNCTION DOC
    au Filetype c nn <silent><buffer> <space>D mdj:keeppatterns ?^\a<CR>O<Esc>O/*<Esc>o<C-w>**<Esc>o*/<Esc>=ipjA<Space><BS><Esc>

    "   NORMINETTE
    au Filetype cpp nn <silent><buffer> <Space>n :w<CR>:!clear; norminette -R CheckDefine %<CR>
    au Filetype c nn <silent><buffer> <Space>n :w<CR>:!clear; norminette -R CheckForbiddenSourceHeader %<CR>

    "   PRINT
    au Filetype c nn <silent><buffer> <Space>p mpodprintf (2, "\n");<Esc>==f\i
    "   PRINT WRAP
    au Filetype c nn <silent><buffer> <Space>P 0<<V:norm f;Di<Esc>Idprintf(2, "> %\n", <Esc>A);<Esc>==f%a

    "   MARKER
    au Filetype c nn <silent><buffer> <Space>m <nop>
    au Filetype c nn <silent><buffer> <Space>mm mmodprintf (2, "(%s: %s: %d)\n",
                \__FILE__, __func__, __LINE__);<Esc>==f%
    au Filetype c nn <silent><buffer> <Space>m1 mmodprintf (2, " #####> 0 <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>m2 mmodprintf (2, " #####> 1 <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>m3 mmodprintf (2, " #####> 2 <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>m4 mmodprintf (2, " #####> 3 <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>m5 mmodprintf (2, " #####> 4 <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>M1 mmodprintf (2, " #####> A <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>M2 mmodprintf (2, " #####> B <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>M3 mmodprintf (2, " #####> C <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>M4 mmodprintf (2, " #####> D <##### \n");<Esc>==
    au Filetype c nn <silent><buffer> <Space>M5 mmodprintf (2, " #####> E <##### \n");<Esc>==
    " }}}
augroup END
