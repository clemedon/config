" @filename  html.vim
" @created   230522 18:07:29  by  clem9nt@imac
" @updated   230522 18:07:29  by  clem9nt@imac
" @author    Clément Vidon

"   options


setlocal path+=$DOTVIM/ftplugin/

let maplocalleader="gh"


"   mappings


nn <silent><buffer> <LocalLeader> <nop>

"   clear
nn <silent><buffer> <LocalLeader>= Mmmgo=G:silent! :%s/\s\+$//e<CR>`mzz3<C-O>

"   format
nn <silent><buffer> <LocalLeader>f mmGgqgo`m
