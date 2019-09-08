lda {z1}
cmp #<{c1}
lda {z1}+1
sbc #>{c1}
bvc !+
eor #$80
!:
beq !e+
bpl {la1}
!e:
