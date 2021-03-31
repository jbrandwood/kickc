pha
ora #$7f
bmi !+
lda #0
!:
sta $ff
clc
pla
adc {m2}
sta {m1}
lda {m2}+1
adc $ff
sta {m1}+1
lda {m2}+2
adc $ff
sta {m1}+2
lda {m2}+3
adc $ff
sta {m1}+3