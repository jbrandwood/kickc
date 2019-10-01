lda ({z2}),y
clc
adc #1
sta {m1}
iny
lda ({z2}),y
adc #0
sta {m1}+1

