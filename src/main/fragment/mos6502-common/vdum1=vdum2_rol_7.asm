lda {m2}+3
lsr
lda {m2}+2
ror
sta {m1}+3
lda {m2}+1
ror
sta {m1}+2
lda {m2}
ror
sta {m1}+1
lda #0
ror
sta {m1}