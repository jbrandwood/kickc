lda {z1}
cmp {z2}
bne !+
lda {z1}+1
cmp {z2}+1
beq {la1}
!: