lda {z1}+1
cmp #>{c1}
bcc !+
bne {la1}
lda {z1}
cmp #<{c1}
bcs {la1}
!:
