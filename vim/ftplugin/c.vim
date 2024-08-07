" @filename  c.vim
" @created   230522 18:00:31  by  clem9nt@imac
" @updated   230522 18:02:48  by  clem9nt@imac
" @author    Clément Vidon

if &filetype ==# 'c'

"   options


setlocal laststatus=2
setlocal path+=
            \$PWD/inc/**,
            \$PWD/incs/**,
            \$PWD/include/**,
            \$PWD/includes/**,
            \$PWD/src/**,
            \$PWD/srcs/**,
            \$PWD/source/**,
            \$PWD/sources/**

let maplocalleader="gh"

let g:gutentags_enabled = 1
let b:surround_45='("\r");'


"   autocommand


"   format au save
"
nn <silent><buffer> <LocalLeader>f :call clangformat#("$HOME/.config/clang-format/.clang-format-c")<CR>
autocmd BufWritePre *.c,*.h exec 'call clangformat#("$HOME/.config/clang-format/.clang-format-c")'


"   mappings


"   settings
nn <LocalLeader>, :e $DOTVIM/ftplugin/c.vim<CR>

nn <silent><buffer> <LocalLeader>mm :w<CR>

"   make
"
nn <silent><buffer> <LocalLeader>mm :w<CR>
            \:!clear<CR>
            \:make!<CR>
            \:cwindow<CR>

"   make clean
nn <silent><buffer> <LocalLeader>mc :w<CR>
            \:!clear<CR>
            \:make! clean<CR>

"   make re
nn <silent><buffer> <LocalLeader>mr :w<CR>
            \:!clear<CR>
            \:make! re<CR>
            \:cwindow<CR>

"   make sure
nn <silent><buffer> <LocalLeader>ms :w<CR>
            \:!clear<CR>
            \:make! sure<CR>
            \:cwindow<CR>

"   make asan
nn <silent><buffer> <LocalLeader>ma :w<CR>
            \:!clear<CR>
            \:make! asan<CR>
            \:cwindow<CR>

"   make leak
nn <silent><buffer> <LocalLeader>ml :w<CR>
            \:!clear<CR>
            \:make! leak<CR>

"   make exec
nn <silent><buffer> <LocalLeader>me :w<CR>
            \:!clear<CR>
            \:make! exec<CR>

"   make test
nn <silent><buffer> <LocalLeader>mt :w<CR>
            \:!clear<CR>
            \:make! test<CR>

"   make help
nn <silent><buffer> <LocalLeader>mh :w<CR>
            \:!clear<CR>
            \:make! each<CR>

"   prod compile run
nn <silent><buffer> <LocalLeader>xx :w\|lcd %:h<CR>
            \
            \:silent !clear; rm -f a.out /tmp/_cerr<CR>
            \:silent !clang -Wall -Wextra -Werror -Wno-unused % 2>/tmp/_cerr<CR>
            \:silent cfile /tmp/_cerr<CR>:silent 5cwindow<CR>
            \:!clear; ./a.out<CR>

"   compile run
nn <silent><buffer> <LocalLeader>e :noau w\|lcd %:h<CR>
            \
            \:!clear; clang -Wall -Wextra -Werror -Wno-unused %
            \ && ./a.out<CR>
nn <silent><buffer> <LocalLeader>E :noau w\|lcd %:h<CR>
            \
            \:!clear; clang -Wall -Wextra -Werror -Wconversion -Wsign-conversion
            \ -pedantic -fsanitize=address,undefined,integer,nullability,vptr
            \ -fno-optimize-sibling-calls -fno-omit-frame-pointer -Og -D DEV %
            \ && ./a.out<CR>

"   docstring skeleton
nn <silent><buffer> <LocalLeader>d mdj
            \
            \:keeppatterns ?^\a<CR>
            \O<Esc>O/**<Esc>o<C-w>* @brief       TODO<CR>
            \<BS>/<Esc>=ip
            \jfT

nn <silent><buffer> <LocalLeader>D mdj
            \
            \:keeppatterns ?^\a<CR>
            \O<Esc>O/**<Esc>o<C-w>* @brief       TODO<CR><CR>
            \@param[out]  TODO<CR>
            \@param[i/o]  TODO<CR>
            \@param[in]   TODO<CR>
            \@return      TODO<CR>
            \<BS>/<Esc>=ip
            \jfT

"   print template
nn <silent><buffer> <LocalLeader>p ofprintf (stdout, "\n");<Esc>==0f"a

"   print current line expression
nn <silent><buffer> <LocalLeader>P 0<<V:norm f;Di<Esc>Ifprintf(stdout, "> %%\n", <Esc>A);<Esc>==0f%l

"   print location
nn <silent><buffer> <LocalLeader>. ofprintf (stdout, "(%s: %s: l.%d)\n", __FILE__, __func__, __LINE__);<Esc>==0f(

"   functions nav
nn <silent><buffer> gzf /^\a<CR>

"   functions list
nn <silent><buffer> gzF :keeppatterns g/^\a<CR>


"   text objects


"   functions
xn <silent><buffer> if <Esc>k/^}$<CR>V%j0ok$
xn <silent><buffer> af <Esc>k/^}$<CR>V%?^$<CR>j
ono <silent><buffer> if :normal Vif<CR>
ono <silent><buffer> af :normal Vaf<CR>

"   functions + docstring
xn <silent><buffer> aF <Esc>k/^}$<CR>V%?/\*<CR>oj
ono <silent><buffer> aF :normal VaF<CR>


"   abbreviations

iabbr <silent><buffer> mmain int main( void ) {<CR>return 0;<CR>}<Esc>kO<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> iinclude #include <stdio.h><CR>#include <stdlib.h><CR>#include <unistd.h><CR><Esc><C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> {{ {<CR>}<Esc>O<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> [[ [<CR>]<Esc>O<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> (( ()<Left><C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> "" ""<Left><C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> '' ''<Left><C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> iif if () {<CR>}<Esc>kf)i<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> eelse else {<CR>}<C-O>O<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> eelseif else if () {<CR>}<Esc>kf)i<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> wwhile while () {<CR>}<Esc>kf)i<C-R>=eatchar#('\s')<CR>
iabbr <silent><buffer> ffor for () {<CR>}<Esc>kf)i<C-R>=eatchar#('\s')<CR>


endif " prevent vim from loading this config for related filetypes
