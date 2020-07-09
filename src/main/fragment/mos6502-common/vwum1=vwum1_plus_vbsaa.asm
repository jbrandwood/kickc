pha
clc
adc {m1}
sta {m1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {m1}+1
sta {m1}+1