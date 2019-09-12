lda #<{c1}
cmp {z1}
lda #>{c1}
sbc {z1}+1
bvc !+
eor #$80
!:
bmi {la1}
