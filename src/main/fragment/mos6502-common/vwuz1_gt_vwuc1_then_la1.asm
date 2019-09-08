lda #>{c1}
cmp {z1}+1
bcc {la1}
bne !+
lda #<{c1}
cmp {z1}
bcc {la1}
!:
