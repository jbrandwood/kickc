ldy #{c2}
clc
lda ({z1}),y
ldy #{c1}
adc ({z1}),y
sta ({z1}),y
ldy #{c2}+1
lda ({z1}),y
ldy #{c1}+1
adc ({z1}),y
sta ({z1}),y
