lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
lda #<{c1}>>16
sta {z1}+2
lda #>{c1}>>16
sta {z1}+3
