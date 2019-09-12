lda {c1},x
cmp {z1}
lda {c1}+1,x
sbc {z1}+1
bvc !+
eor #$80
!:
bmi {la1}
!e:
