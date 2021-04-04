ldy #0
clc
lda #<{c1}
adc ({z1}),y
pha
iny
lda #>{c1}
adc ({z1}),y
sta {z1}+1
pla
sta {z1}