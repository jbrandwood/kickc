lda {z1}+1
sta $ff
lda {z1}
sta {z1}+1
lda #0
sta {z1}
lsr $ff
ror {z1}+1
ror {z1}
lsr $ff
ror {z1}+1
ror {z1}