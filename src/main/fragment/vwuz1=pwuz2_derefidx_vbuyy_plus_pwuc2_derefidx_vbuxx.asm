lda ({z2}),y
clc
adc {c2},x
sta {z1}
iny
lda ({z2}),y
adc {c2}+1,x
sta {z1}+1

