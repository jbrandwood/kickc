ldy #0
lda ({z2}),y
tay
lda ({z1}),y
clc
adc #1
sta ({z1}),y