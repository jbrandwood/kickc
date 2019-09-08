lda #<{c1}
eor {z1}
sta {z1}
lda #>{c1}
eor {z1}+1
sta {z1}+1
