lda #<{c2}
sta {c1},x
lda #>{c2}
sta {c1}+1,x
lda #<{c2}>>16
sta {c1}+2,x
lda #>{c2}>>16
sta {c1}+3,x