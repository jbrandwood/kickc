lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
cpx #0
beq !e+
!:
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
dex
bne !-
!e: