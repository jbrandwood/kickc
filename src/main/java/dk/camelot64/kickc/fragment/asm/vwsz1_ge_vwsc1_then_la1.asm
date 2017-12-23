lda {z1}
cmp #<{c1}
lda {z1}+1
sbc #>{c1}
bvc !+
eor #$80
!:
bpl {la1}
