lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda ($fe),y
ldy #{c1}
sta ($fe),y