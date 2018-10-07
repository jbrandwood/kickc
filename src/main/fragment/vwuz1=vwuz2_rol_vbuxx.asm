lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
cpx #0
beq !e+
!:
asl {z1}
rol {z1}+1
dex
bne !-
!e: