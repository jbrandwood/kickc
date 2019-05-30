tax
clc
adc #<{c1}
sta {z1}
txa
ora #$7f
bmi !+
lda #0
!:
adc #>{c1}
sta {z1}+1
