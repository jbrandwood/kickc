lda {m2}+1
cmp {m1}+1
bcc !+
bne {la1}
lda {m2}
cmp {m1}
bcs {la1}
!:
