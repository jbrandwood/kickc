ldy #0
clc
lda ({z2}),y
adc #<{c1}
sta ({z1}),y
iny
lda ({z2}),y
adc #>{c1}
sta ({z1}),y