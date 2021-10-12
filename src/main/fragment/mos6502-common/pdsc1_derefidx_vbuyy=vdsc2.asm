lda #<{c2}
sta {c1},y
lda #>{c2}
sta {c1}+1,y
lda #<{c2}>>16
sta {c1}+2,y
lda #>{c2}>>16
sta {c1}+3,y