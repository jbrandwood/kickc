lda {c1}+1,y
cmp #>{c2}
bcc {la1}
bne !+
lda {c1},y
cmp #<{c2}
bcc {la1}
!:
