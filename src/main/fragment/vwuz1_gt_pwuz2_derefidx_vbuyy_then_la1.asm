iny
lda ({z2}),y
cmp {z1}+1
bcc {la1}
bne !+
dey
lda ({z2}),y
cmp {z1}
bcc {la1}
!:
