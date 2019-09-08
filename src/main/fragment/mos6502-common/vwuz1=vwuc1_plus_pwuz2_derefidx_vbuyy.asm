clc
lda #<{c1}
adc ({z2}),y
sta {z1}
iny
lda #>{c1}
adc ({z2}),y
sta {z1}+1
