sec
lda {c1},y
sbc {c2},y
sta {z1}
lda {c1}+1,y
sbc {c2}+1,y
sta {z1}+1
