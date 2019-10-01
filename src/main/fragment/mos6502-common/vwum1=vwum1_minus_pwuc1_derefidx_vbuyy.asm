sec
lda {m1}
sbc {c1},y
sta {m1}
lda {m1}+1
sbc {c1}+1,y
sta {m1}+1
