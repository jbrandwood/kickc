cpy #0
beq !e+
!:
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
dey
bne !-
!e: