lda {z1}
cmp {z2}
lda {z1}+1
sbc {z2}+1
bvc !+
eor #$80
!:
beq !e+
bpl {la1}
!e: