lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda ($fe),y
sec
sbc #1
sta ($fe),y