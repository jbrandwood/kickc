sec
lda {z1}
sbc #1
sta {z1}
bcs !+
dec {z1}+1
!: