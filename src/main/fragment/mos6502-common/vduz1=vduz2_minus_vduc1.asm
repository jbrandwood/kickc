lda {z2}
sec
sbc #<{c1}
sta {z1}
lda {z2}+1
sbc #>{c1}
sta {z1}+1
lda {z2}+2
sbc #<{c1}>>$10
sta {z1}+2
lda {z2}+3
sbc #>{c1}>>$10
sta {z1}+3
