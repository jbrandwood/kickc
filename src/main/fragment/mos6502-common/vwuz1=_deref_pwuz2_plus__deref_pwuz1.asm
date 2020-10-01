ldy #0
clc
lda ({z1}),y
adc ({z2}),y
pha
iny
lda ({z1}),y
adc ({z2}),y
sta ({z1}),y
dey
pla
sta ({z1}),y