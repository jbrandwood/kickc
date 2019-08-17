ldy #1
lda {z1}+1
cmp ({z2}),y
bcc {la1}
bne !+
dey
lda {z1}
cmp ({z2}),y
bcc {la1}
!:
