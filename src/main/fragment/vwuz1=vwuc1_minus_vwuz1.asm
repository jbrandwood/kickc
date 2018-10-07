sec
lda #<{c1}
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
