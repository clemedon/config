" ftplugin/noesis
" Created: 230524 20:45:19 by clem9nt@imac
" Updated: 230601 14:58:07 by cvidon@e2r3p15.clusters.42paris.fr
" Maintainer: Clément Vidon

"   options


setlocal suffixesadd+=.md
setlocal suffixesadd+=.gpg.md
setlocal path+=$DOTVIM/pack/vendor/start/noesis/**,
            \$NOESIS,
            \$NOESIS/Lists/**,
            \$NOESIS/Areas/**,
            \$NOESIS/Projects/**,
            \$NOESIS/Resources/**
setlocal expandtab
set foldmethod=marker
set foldmarker=->>>,<<<-
let maplocalleader = "gh"


"   mappings


nn <buffer><silent> <LocalLeader> <nop>
nn <silent><buffer> <space>= <nop>
vn <silent><buffer> <space>= <nop>
vn <silent><buffer> = <nop>
nn <silent><buffer> = <nop>
vn <silent><buffer> gq <nop>
nn <silent><buffer> gq <nop>
nn <silent><buffer> gwG <nop>
nn <silent><buffer> gwgo <nop>
nn <silent><buffer> gwgg <nop>


"   info
nn <silent><buffer> <LocalLeader>? :echo "
            \\n
            \================[Noesis]================\n
            \                                      \|\n
            \ HTML_EXPORT       : Space X          \|\n
            \                                      \|\n
            \"<CR>


"   noesis grep TODO neovim support
com! -nargs=+ Grep exec 'grep! -i <args> $NOESIS/**/*.md' | cw


"   git pull
nn <silent><buffer> <LocalLeader>pl :cd %:h\|sil !git pull<CR>:redraw!<CR>

"   git add commit push TODO
nn <silent><buffer> <LocalLeader>ps :echo "Push"<CR>:w\|lc %:h<CR>
            \
            \:sil !rm $DOTVIM/.swp/*%*.swp<CR>
            \:sil cd $NOESIS/<CR>
            \:sil !git add -f INDEX.md Lists Areas Projects Resources Archives<CR>
            \:sil !git commit -m "Push"<CR>:sil !git push origin main<CR>
            \:q<CR>:redr!<CR>


"   gpg enc / dec
nn <buffer><silent> <LocalLeader>en :silent %!gpg --default-recipient Clem9nt -ae 2>/dev/null<CR>
nn <buffer><silent> <LocalLeader>de :silent %!gpg -d 2>/dev/null<CR>

"   more gpg enc / dec
vn <silent><buffer> <LocalLeader>gs :!gpg -ca<CR>:echo "gpg -ca # --symetric --armor"
vn <silent><buffer> <LocalLeader>ga :!gpg -ae<CR>dd:echo "gpg -ae # --"
vn <silent><buffer> <LocalLeader>gd :!gpg -qd<CR>:echo "gpg -qd"


"   french to english
nn <buffer><silent> <LocalLeader>len v$y:En <C-R>"<CR>
vn <buffer><silent> <LocalLeader>len y:En <C-R>"<CR>

"   english to french
nn <buffer><silent> <LocalLeader>lfr v$y:Fr <C-R>"<CR>
vn <buffer><silent> <LocalLeader>lfr y:Fr <C-R>"<CR>

"   english synonym
vn <buffer><silent> <LocalLeader>sy y:Sy <C-R>"<CR>


no <C-K>% <Nop>
no <C-K>% <Nop>

exec "digraphs es " . 0x2091
exec "digraphs hs " . 0x2095
exec "digraphs is " . 0x1D62
exec "digraphs js " . 0x2C7C
exec "digraphs ks " . 0x2096
exec "digraphs ls " . 0x2097
exec "digraphs ms " . 0x2098
exec "digraphs ns " . 0x2099
exec "digraphs os " . 0x2092
exec "digraphs ps " . 0x209A
exec "digraphs rs " . 0x1D63
exec "digraphs ss " . 0x209B
exec "digraphs ts " . 0x209C
exec "digraphs us " . 0x1D64
exec "digraphs vs " . 0x1D65
exec "digraphs xs " . 0x2093

exec "digraphs aS " . 0x1d43
exec "digraphs bS " . 0x1d47
exec "digraphs cS " . 0x1d9c
exec "digraphs dS " . 0x1d48
exec "digraphs eS " . 0x1d49
exec "digraphs fS " . 0x1da0
exec "digraphs gS " . 0x1d4d
exec "digraphs hS " . 0x02b0
exec "digraphs iS " . 0x2071
exec "digraphs jS " . 0x02b2
exec "digraphs kS " . 0x1d4f
exec "digraphs lS " . 0x02e1
exec "digraphs mS " . 0x1d50
exec "digraphs nS " . 0x207f
exec "digraphs oS " . 0x1d52
exec "digraphs pS " . 0x1d56
exec "digraphs rS " . 0x02b3
exec "digraphs sS " . 0x02e2
exec "digraphs tS " . 0x1d57
exec "digraphs uS " . 0x1d58
exec "digraphs vS " . 0x1d5b
exec "digraphs wS " . 0x02b7
exec "digraphs xS " . 0x02e3
exec "digraphs yS " . 0x02b8
exec "digraphs zS " . 0x1dbb

exec "digraphs AS " . 0x1D2C
exec "digraphs BS " . 0x1D2E
exec "digraphs DS " . 0x1D30
exec "digraphs ES " . 0x1D31
exec "digraphs GS " . 0x1D33
exec "digraphs HS " . 0x1D34
exec "digraphs IS " . 0x1D35
exec "digraphs JS " . 0x1D36
exec "digraphs KS " . 0x1D37
exec "digraphs LS " . 0x1D38
exec "digraphs MS " . 0x1D39
exec "digraphs NS " . 0x1D3A
exec "digraphs OS " . 0x1D3C
exec "digraphs PS " . 0x1D3E
exec "digraphs RS " . 0x1D3F
exec "digraphs TS " . 0x1D40
exec "digraphs US " . 0x1D41
exec "digraphs VS " . 0x2C7D
exec "digraphs WS " . 0x1D42