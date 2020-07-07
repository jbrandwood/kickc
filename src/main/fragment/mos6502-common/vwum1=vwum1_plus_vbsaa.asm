sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
clc
lda {m1}
adc $fe
sta {m1}
lda {m1}+1
adc $ff
sta {m1}+1