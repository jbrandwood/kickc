lda ({z1}),y
sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
ldy #{c1}
clc
lda ({z1}),y
adc $fe
sta ({z1}),y
iny
lda ({z1}),y
adc $fe
sta ({z1}),y