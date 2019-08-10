lda {z1}+1
bne {la1}
clc
lda {z1}
cmp {c1}
bcc !+
bcs {la1}
!:
