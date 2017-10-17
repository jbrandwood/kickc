lda {zpptrby1}+1
cmp #>{cowo1}
bcc {la1}
bne !+
lda {zpptrby1}
cmp #<{cowo1}
bcc {la1}
!: