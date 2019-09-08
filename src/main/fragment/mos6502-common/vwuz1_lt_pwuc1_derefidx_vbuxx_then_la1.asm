lda {z1}+1
cmp {c1}+1,x
bcc {la1}
bne !+
lda {z1}
cmp {c1},x
bcc {la1}
!:
