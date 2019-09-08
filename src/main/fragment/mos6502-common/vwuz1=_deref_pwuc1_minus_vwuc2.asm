sec
lda {c1}
sbc #<{c2}
sta {z1}
lda {c1}+1
sbc #>{c2}
sta {z1}+1