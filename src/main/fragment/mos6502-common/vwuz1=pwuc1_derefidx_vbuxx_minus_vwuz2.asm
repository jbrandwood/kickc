sec
lda {c1},x
sbc {z2}
sta {z1}
lda {c1}+1,x
sbc {z2}+1
sta {z1}+1