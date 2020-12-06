ldy #0
clc
lda ({z2}),y
adc {m3}
sta {m1}
iny
lda ({z2}),y
adc {m3}+1
sta {m1}+1