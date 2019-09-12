lda {z2}
cmp {z1}
lda {z2}+1
sbc {z1}+1
bvc !+
eor #$80
!:
bmi {la1}
!e: