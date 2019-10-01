lda #<{c1}
sec
sbc {c2}
sta {m1}
lda #>{c1}
sbc {c2}+1
sta {m1}+1
lda #<{c1}>>$10
sbc {c2}+2
sta {m1}+2
lda #>{c1}>>$10
sbc {c2}+3
sta {m1}+3
