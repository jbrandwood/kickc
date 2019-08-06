sta $ff
lda {z2}
ora $ff
sta {z1}
lda {z2}+1
sta {z1}+1
