sec
lda {m1}
sbc #{c1}
sta {m1}
bcs !+
dec {m1}+1
!:
