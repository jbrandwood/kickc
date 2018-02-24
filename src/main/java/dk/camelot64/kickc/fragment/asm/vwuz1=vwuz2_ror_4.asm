lda {z2}+1
sta {z1}+1
lda {z2}
sta {z1}
ldy #4
!:
lsr {z1}+1
ror {z1}
dey
bne !-