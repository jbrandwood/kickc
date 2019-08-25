lda {c1},y
cmp {z1}
lda {c1}+1,y
sbc {z1}+1
bvc !+
eor #$80
!:
bpl {la1}
