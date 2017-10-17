lda {zpptrby1}+1
cmp {zpptrby2}+1
bcc {la1}
bne !+
lda {zpptrby1}
cmp {zpptrby2}
bcc {la1}
!: