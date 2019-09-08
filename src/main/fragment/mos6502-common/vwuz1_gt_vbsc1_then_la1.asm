lda #{c1}
bmi {la1}
cmp {z1}
bcc {la1}
lda {z1}+1
bne {la1}