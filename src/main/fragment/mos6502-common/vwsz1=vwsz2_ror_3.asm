lda {z2}+1
cmp #$80
ror
sta {z1}+1
lda {z2}
ror
sta {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}
lda {z1}+1
cmp #$80
ror {z1}+1
ror {z1}

