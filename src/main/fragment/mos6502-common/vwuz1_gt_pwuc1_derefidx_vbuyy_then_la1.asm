lda {c1}+1,y
cmp {z1}+1
bcc {la1}
bne !+
lda {c1},y
cmp {z1}
bcc {la1}
!:
