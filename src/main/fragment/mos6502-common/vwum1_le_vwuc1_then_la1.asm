lda {m1}+1
cmp #>{c1}
bne !+
lda {m1}
cmp #<{c1}
!:
bcc {la1}
beq {la1}
