lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
cpy #0
beq !e+
!:
lsr {z1}+1
ror {z1}
dey
bne !-
!e: