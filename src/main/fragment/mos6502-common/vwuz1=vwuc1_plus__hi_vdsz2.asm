clc
lda #<{c1}
adc {z2}+2
sta {z1}
lda #>{c1}
adc {z2}+3
sta {z1}+1
