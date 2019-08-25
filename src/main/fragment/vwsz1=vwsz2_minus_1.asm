sec
lda {z2}
sbc #1
sta {z1}
bcs !+
lda {z2}+1
sbc #0
sta {z1}+1
!: