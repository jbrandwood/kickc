sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
clc
lda {z1}
adc $fe
sta {z1}
lda {z1}+1
adc $ff
sta {z1}+1
