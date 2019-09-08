lda {z1}
cmp {c1},y
lda {z1}+1
sbc {c1}+1,y
bvc !+
eor #$80
!:
beq !e+
bpl {la1}
!e:
