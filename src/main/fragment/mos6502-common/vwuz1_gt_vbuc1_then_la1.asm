lda {z1}+1
bne {la1}
lda {z1}
cmp #{c1}
beq !+
bcs {la1}
!: