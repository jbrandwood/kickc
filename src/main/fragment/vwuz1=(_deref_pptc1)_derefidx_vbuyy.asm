ldx {c1}
stx $fe
ldx {c1}+1
stx $ff
lda ($fe),y
sta {z1}
iny
lda ($fe),y
sta {z1}+1
