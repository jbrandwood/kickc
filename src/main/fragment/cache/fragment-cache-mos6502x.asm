//KICKC FRAGMENT CACHE 1695362db1
//FRAGMENT _deref_(_deref_qwuc1)=_deref_(_deref_qwuc2)
ldy {c2}
sty $fe
ldy {c2}+1
sty $ff
ldy #0
lda ($fe),y
ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y
