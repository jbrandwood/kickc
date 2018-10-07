lda {z1}
sec
sbc #<{c1}
sta {z2}
lda {z1}+1
sbc #>{c1}
sta {z2}+1
