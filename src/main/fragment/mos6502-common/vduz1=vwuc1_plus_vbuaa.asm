clc
adc #<{c1}
sta {z1}
lda #0
adc #>{c1}
sta {z1}+1
lda #0
adc #0
sta {z1}+2
lda #0
sta {z1}+3

