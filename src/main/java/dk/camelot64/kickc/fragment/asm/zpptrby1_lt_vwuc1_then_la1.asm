lda {zpptrby1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {zpptrby1}
cmp #<{c1}
bcc {la1}
!:
