sec
lda {c1},x
sbc {c2},y
sta {z1}
lda {c1}+1,x
sbc {c2}+1,y
sta {z1}+1
