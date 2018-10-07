lda {z1}+3
cmp #>{c1}>>$10
bcc {la1}
bne !+
lda {z1}+2
cmp #<{c1}>>$10
bcc {la1}
bne !+
lda {z1}+1
cmp #>{c1}
bcc {la1}
bne !+
lda {z1}
cmp #<{c1}
bcc {la1}
!:
