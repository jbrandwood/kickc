lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
cpx #0
beq !e+
!:
lsr {z1}+3
ror {z1}+2
ror {z1}+1
ror {z1}
dex
bne !-
!e: