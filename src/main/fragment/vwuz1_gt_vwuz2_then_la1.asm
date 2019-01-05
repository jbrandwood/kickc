lda {z2}+1
cmp {z1}+1
bne !+
lda {z2}
cmp {z1}
!:
bcc {la1}
beq {la1}
