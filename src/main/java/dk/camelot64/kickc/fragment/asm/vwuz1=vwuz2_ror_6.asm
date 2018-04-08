lda {z2}+1
sta {z1}+1
lda {z2}
sta {z1}
ldy #6
!:
lsr {z1}+1
ror {z1}
dey
bne !-