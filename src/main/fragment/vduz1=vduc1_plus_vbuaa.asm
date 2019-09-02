clc
adc #<{c1}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
lda #<{c1}>>$10
adc #0
sta {z1}+2
lda #>{c1}>>$10
adc #0
sta {z1}+3
