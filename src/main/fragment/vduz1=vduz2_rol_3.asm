lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
lda {z2}+2
sta {z1}+2
lda {z2}+3
sta {z1}+3
ldy #3
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
