lda {z1}
sec
sbc #{c1}
sta {z1}
bcs !+
dec {z1}+1
!:
