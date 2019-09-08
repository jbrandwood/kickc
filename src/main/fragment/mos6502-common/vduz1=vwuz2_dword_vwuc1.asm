lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
lda {z2}
sta {z1}+2
lda {z2}+1
sta {z1}+3
