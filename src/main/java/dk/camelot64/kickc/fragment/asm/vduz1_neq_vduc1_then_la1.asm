lda {z1}+3
cmp #>{c1}>>16
bne {la1}
lda {z1}+2
cmp #<{c1}>>16
bne {la1}
lda {z1}+1
cmp #>{c1}
bne {la1}
lda {z1}
cmp #<{c1}
bne {la1}
