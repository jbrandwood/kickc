sec
lda {c1},y
sbc {c2},x
sta {z1}
lda {c1}+1,y
sbc {c2}+1,x
sta {z1}+1
