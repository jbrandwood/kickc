lda #<{c1}
sec
sbc {z1}
sta {z1}
lda #>{c1}
sbc {z1}+1
sta {z1}+1
lda #<{c1}>>$10
sbc {z1}+2
sta {z1}+2
lda #>{c1}>>$10
sbc {z1}+3
sta {z1}+3
