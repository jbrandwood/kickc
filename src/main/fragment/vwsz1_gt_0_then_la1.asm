lda {z1}+1
bne !+
lda {z1}
beq !e+
lsr
!:
bpl {la1}
!e: