txa
clc
adc #<{c1}
sta {z1}
lda #0
adc #>{c1}
sta {z1}+1
