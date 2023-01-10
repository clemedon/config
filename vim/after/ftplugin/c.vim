augroup filetype_c
    autocmd!

    " --------------------------------- OPTIONS >>>

    " .......................... BUILTIN

    au FileType qf setl wrap
    au FileType c,cpp setl expandtab tabstop=2 shiftwidth=2 textwidth=80
    au FileType c,cpp setl softtabstop=2 autoindent cindent
    au FileType c,cpp setl formatprg=clang-format\ --style=file
    au FileType c,cpp let mapleader="<BS>"
    au FileType c,cpp,make setl path+=$PWD/include/,$PWD/src/**

    " .......................... PLUGIN

    au FileType c,cpp let g:gutentags_enabled = 1
    au FileType c,cpp let b:surround_45 = '("\r");'

    " <<<

    " --------------------------------- MAPPINGS >>>

    " .......................... PRIMARY (GH?)

    au Filetype c,cpp nn <silent><buffer> gh <nop>

    " ............... RUN

    "   Make + run
    au Filetype c,cpp nn <silent><buffer> ghm :w<CR>
                \
                \:!clear; make -j 2>/tmp/_err<CR>
                \:cfile /tmp/_err<CR>
                \:5cw<CR>
                \:!clear; ./$(ls -t \| head -1 \| grep -v /tmp/_err)<CR>

    "   Make asan + run
    au Filetype c,cpp nn <silent><buffer> gha :w<CR>
                \
                \:!clear; make -j asan && ./$(ls -t \| head -1)<CR>

    "   Make + valgrind run
    au Filetype c,cpp nn <silent><buffer> ghv :w<CR>
                \
                \:!clear; make -j && valgrind -q ./$(ls -t \| head -1)<CR>

    " TODO remove exec

    "   Compile + run
    au Filetype c nn <silent><buffer> ghr :w\|lc %:h<CR>
                \
                \:exec 'silent !rm -f a.out /tmp/_err'<CR>
                \:exec 'silent !clang -Werror -Wall -Wextra % 2>/tmp/_err'<CR>
                \:cfile /tmp/_err<CR>
                \:5cw<CR>
                \:exec '!clear; ./a.out'<CR>

    au Filetype cpp nn <silent><buffer> ghr :w\|lc %:h<CR>
                \
                \:!rm -f a.out /tmp/_err<CR>
                \:silent !c++ -Werror -Wall -Wextra % 2>/tmp/_err<CR>
                \:cfile /tmp/_err<CR>
                \:5cw<CR>
                \:!clear; ./$(ls -t \| head -1 \| grep -v /tmp/_err)<CR>

    " ............... CLEAN CODE

    "   Docstring
    au Filetype c,cpp nn <silent><buffer> ghd mdj
                \
                \:keeppatterns ?^\a<CR>
                \O<Esc>O/**<Esc>o<C-w>* @brief       .<CR><CR>
                \@param[out]  .<CR>
                \@param[in]   .<CR>
                \@return      .<CR>
                \<BS>/<Esc>=ip
                \jf.

    "   Format
    au Filetype c,cpp nn <silent><buffer> ghf :call FormatCurrentFile()<CR>

    " ............... DEBUG

    "   Print wrapped
    au Filetype c nn <silent><buffer> ghw 0<<V:norm f;Di<Esc>Idprintf(2, "> %\n", <Esc>A);<Esc>==f%a
    au Filetype cpp nn <silent><buffer> ghw 0<<V:norm f;Di<Esc>Istd::cerr << ">" << <Esc>A << std::endl;<Esc>==f"a

    "   Print location
    au Filetype c nn <silent><buffer> ghl odprintf (2, "(%s: %s: l.%d)\n", __FILE__, __func__, __LINE__);<Esc>==f(
    au Filetype cpp nn <silent><buffer> ghl ostd::cerr << "(" << __FILE__ << ": " << __func__  << ": l." << __LINE__ << ")" << std::endl;<Esc>==f(

    " ............... NAV

    "   Switch from %.hpp to %.cpp and vis versa
    function SwitchHppCpp()
        if match(expand('%:e'), 'cpp')
            find %<.cpp
        elseif match(expand('%:e'), 'hpp')
            find %<.hpp
        endif
    endfunction
    au Filetype cpp nn <silent><buffer> ghs :call SwitchHppCpp()<CR>

    " .......................... SECONDARY (GZ??)

    "   Functions nav
    au Filetype c,cpp nn <silent><buffer> gzfn /^\a<CR>

    "   Functions list
    au Filetype c,cpp nn <silent><buffer> gzfl :keeppatterns g/^\a<CR>

    "   New Class
    function ClassInitCpp()
        if  (expand("%:e") == "cpp")
            if  (expand(line('$')) == 1 && getline(1) =~ '^$')
                let className = expand("%:t:r")
                call append(0, "#include \"" . className . ".hpp\"")
                call append(1, "")
                call append(2, className . "::" . className . " (void) {")
                call append(3, "}")
                call append(4, "")
                call append(5, className . "::~" . className . " (void) {")
                call append(6, "}")
                call search("void")
            endif
        elseif  (expand("%:e") == "hpp")
            if  (expand(line('$')) == 1 && getline(1) =~ '^$')
                let className = expand("%:t:r")
                let includeGuard = toupper (className . '_HPP_')
                call append(0, "#ifndef " . includeGuard)
                call append(1, "#define " . includeGuard)
                call append(2, "")
                call append(3, "class " . className . " {")
                call append(4, " public:")
                call append(5, "  " . className . " (void);")
                call append(6, "  ~" . className . " (void);")
                call append(7, "")
                call append(8, " private:")
                call append(9, "};")
                call append(line("$"), "#endif  // " . includeGuard)
                call search("void")
            elseif !(getline(expand(line('$'))) =~ '#endif') && !(getline(1) =~ '#ifndef')
                let className = expand("%:t:r")
                let includeGuard = toupper (className . '_HPP_')
                call append(0, "#ifndef " . includeGuard)
                call append(1, "#define " . includeGuard)
                call append(2, "")
                call append(line("$"), "")
                call append(line("$"), "#endif  // " . includeGuard)
            endif
        endif
    endfunction
    au Filetype c,cpp nn <silent><buffer> gzci :call ClassInitCpp()<CR>

    " .......................... TEXT OBJECTS

    "   Functions
    au Filetype c,cpp xn <silent><buffer> if /^}$<CR>on%j0ok
    au Filetype c,cpp xn <silent><buffer> af /^}$<CR>on%?^$<CR>
    au Filetype c,cpp ono <silent><buffer> if :normal Vif<CR>
    au Filetype c,cpp ono <silent><buffer> af :normal Vaf<CR>

    "   Functions + docstring
    au Filetype c,cpp xn <silent><buffer> aF /^}$<CR>on%?^$<CR>n
    au Filetype c,cpp ono <silent><buffer> aF :normal VaF<CR>

    " .......................... ABBREVIATIONS
    "
    au Filetype cpp iabbr <silent><buffer> main int main () {<CR>return 0;<CR>}<Esc>kO<C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> { {<CR>}<Esc>O<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> if if () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> else else {<CR>}<C-O>O<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> elseif else if () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> while while () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> for for () {<CR>}<Esc>kf)i<C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> sstr std::string
    au Filetype cpp iabbr <silent><buffer> "" ""<Left><C-R>=Eatchar('\s')<CR>
    au Filetype cpp iabbr <silent><buffer> '' ''<Left><C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> sscin   std::cin >>;<Left>
    au Filetype cpp iabbr <silent><buffer> sscerr  std::cerr <<;<Left>
    au Filetype cpp iabbr <silent><buffer> sscout  std::cout <<;<Left>

    au Filetype cpp iabbr <silent><buffer> scin    std::cin
    au Filetype cpp iabbr <silent><buffer> scerr   std::cerr
    au Filetype cpp iabbr <silent><buffer> scout   std::cout
    au Filetype cpp iabbr <silent><buffer> sendl   std::endl<C-R>=Eatchar('\s')<CR>

    au Filetype cpp iabbr <silent><buffer> pcerr std::cerr << << std::endl;<Esc>13hi
    au Filetype cpp iabbr <silent><buffer> pcout std::cout << << std::endl;<Esc>13hi

    " <<<

    " --------------------------------- HIGHLIGHTS >>>

    " .......................... COLORS

    if &background == "dark"
        au FileType c,cpp hi Search ctermbg=NONE ctermfg=105
        au FileType c,cpp hi mycDebug ctermfg=158
        au FileType c,cpp hi cString ctermfg=102
        au FileType c,cpp hi cTodo ctermfg=84
        au FileType c,cpp hi cComment ctermfg=103
        au FileType c,cpp hi link cCommentL cComment
        au FileType c,cpp hi link cCommentStart cComment
    elseif &background == "light"
        au FileType c,cpp hi Search ctermbg=229 ctermfg=NONE
        au FileType c,cpp hi mycDebug ctermfg=31
        au FileType c,cpp hi cString ctermfg=245
        au FileType c,cpp hi cTodo ctermfg=205
        au FileType c,cpp hi cComment ctermfg=103
        au FileType c,cpp hi link cCommentL cComment
        au FileType c,cpp hi link cCommentStart cComment
    endif

    " .......................... PATTERN

    " au FileType c,cpp syn match mycConstant "\v\w@<!(\u|_+[A-Z0-9])[A-Z0-9_]*\w@!"
    " au FileType c,cpp hi link mycConstant cConstant
    au FileType c,cpp syn match mycDebug "printf\|dprintf" contains=cString,cComment,cCommentL
    au FileType c,cpp syn keyword cTodo DONE
    au FileType c,cpp syn keyword cTodo WHY
    au FileType c,cpp syn keyword cTodo TRY

    " .......................... OFF

    " au FileType c,cpp hi link cConditional cleared
    " au FileType c,cpp hi link cRepeat cleared
    " au FileType c,cpp hi link cStatement cleared
    au FileType c,cpp hi link cCharacter cleared
    au FileType c,cpp hi link cConstant cleared
    au FileType c,cpp hi link cDefine cleared
    au FileType c,cpp hi link cInclude cleared
    au FileType c,cpp hi link cIncluded cleared
    au FileType c,cpp hi link cIncluded cleared
    au FileType c,cpp hi link cNumber cleared
    au FileType c,cpp hi link cOperator cleared
    au FileType c,cpp hi link cPreCondit cleared
    au FileType c,cpp hi link cSpecial cleared
    au FileType c,cpp hi link cStorageClass cleared
    au FileType c,cpp hi link cStructure cleared
    au FileType c,cpp hi link cType cleared
    au FileType c,cpp hi link cTypedef cleared
    au FileType c,cpp hi link cppBoolean cleared
    au FileType c,cpp hi link cppNumber cleared
    au FileType c,cpp hi link cppStatement cleared
    au FileType c,cpp hi link cppStructure cleared
    au FileType c,cpp hi link cppType cleared

    " <<<

augroup END
