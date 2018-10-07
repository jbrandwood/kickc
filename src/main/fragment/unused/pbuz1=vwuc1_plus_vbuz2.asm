lda #<{c1}
clc
adc {z2}
sta {z1}
lda #>{c1}
adc #0
sta {z1}+1
