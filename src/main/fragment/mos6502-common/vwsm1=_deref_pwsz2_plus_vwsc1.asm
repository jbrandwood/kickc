ldy #0
lda ({z2}),y
clc
adc #<{c1}
sta {m1}
iny
lda ({z2}),y
adc #>{c1}
sta {m1}+1
