ldy #0
clc
lda ({z2}),y
adc ({z3}),y
sta ({z1}),y
iny
lda ({z2}),y
adc ({z3}),y
sta ({z1}),y