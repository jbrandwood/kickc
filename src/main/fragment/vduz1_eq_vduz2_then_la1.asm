lda {z1}
cmp {z2}
bne !+
lda {z1}+1
cmp {z2}+1
bne !+
lda {z1}+2
cmp {z2}+2
bne !+
lda {z1}+3
cmp {z2}+3
beq {la1}
!: