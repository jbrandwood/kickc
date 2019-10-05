lda {m1}
sec
sbc #2
sta {m1}
bcs !+
dec {m1}+1
!:
