sec
lda {c1},x
sbc {z1}
sta {c1},x
bcs !+
dec {c1}+1,x
!:
