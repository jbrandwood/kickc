pha
clc
adc #<{c1}
sta {m1}
pla
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {m1}+1