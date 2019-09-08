sec
lda {z1}
sbc #{c1}
sta {z1}
bcs !+
dec {z1}+1
!: