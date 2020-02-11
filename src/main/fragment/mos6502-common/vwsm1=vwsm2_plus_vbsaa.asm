sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
clc
lda {m2}
adc $fe
sta {m1}
lda {m2}+1
adc $ff
sta {m1}+1