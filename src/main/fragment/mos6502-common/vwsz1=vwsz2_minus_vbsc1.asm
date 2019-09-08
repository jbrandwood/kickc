lda {z2}
sec
sbc #{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1