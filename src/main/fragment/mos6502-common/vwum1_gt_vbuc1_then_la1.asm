lda {m1}+1
bne {la1}
lda {m1}
cmp #{c1}
beq !+
bcs {la1}
!:
