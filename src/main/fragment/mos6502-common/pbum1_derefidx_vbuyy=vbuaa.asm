sty $fd
ldy {m1}
sty $fe
ldy {m1}+1
sty $ff
ldy $fd
sta ($fe),y
