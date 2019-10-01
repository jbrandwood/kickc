sec
lda {m1}
sbc {c1},x
sta {m1}
lda {m1}+1
sbc {c1}+1,x
sta {m1}+1
