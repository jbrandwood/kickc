sec
lda #<{c1}
sbc {z2}
sta {z1}
lda #>{c1}
sbc #0
sta {z1}+1