pha
clc
adc {m2}
sta {m1}
pla
ora #$7f
bmi !+
lda #0
!:
adc {m2}+1
sta {m1}+1