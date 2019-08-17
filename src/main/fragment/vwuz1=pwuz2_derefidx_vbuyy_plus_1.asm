lda ({z2}),y
clc
adc #1
sta {z1}
iny
lda ({z2}),y
adc #0
sta {z1}+1

