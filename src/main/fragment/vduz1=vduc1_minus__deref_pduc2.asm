lda #<{c1}
sec
sbc {c2}
sta {z1}
lda #>{c1}
sbc {c2}+1
sta {z1}+1
lda #<{c1}>>$10
sbc {c2}+2
sta {z1}+2
lda #>{c1}>>$10
sbc {c2}+3
sta {z1}+3
