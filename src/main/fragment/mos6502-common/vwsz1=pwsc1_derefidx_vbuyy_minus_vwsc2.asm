sec
lda {c1},y
sbc #<{c2}
sta {z1}
lda {c1}+1,y
sbc #>{c2}
sta {z1}+1