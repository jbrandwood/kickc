lda {m1}+3
cmp {m2}+3
bcc {la1}
bne !+
lda {m1}+2
cmp {m2}+2
bcc {la1}
bne !+
lda {m1}+1
cmp {m2}+1
bcc {la1}
bne !+
lda {m1}
cmp {m2}
bcc {la1}
!:
