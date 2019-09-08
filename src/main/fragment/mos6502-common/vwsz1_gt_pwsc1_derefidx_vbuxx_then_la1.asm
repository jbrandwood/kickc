lda {z1}
cmp {c1},x
lda {z1}+1
sbc {c1}+1,x
bvc !+
eor #$80
!:
beq !e+
bpl {la1}
!e:
