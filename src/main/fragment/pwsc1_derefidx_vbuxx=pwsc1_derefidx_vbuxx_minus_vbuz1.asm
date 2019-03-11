sec
lda {c1},x
sbc {z1}
sta {c1},x
lda {c1}+1,x
sbc #0
sta {c1}+1,x