lda {z2}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
lda {z1}
clc
adc {z2}
sta {z1}
lda {z1}+1
adc {z2}+1
sta {z1}+1
lda {z1}+2
adc $ff
sta {z1}+2
lda {z1}+3
adc $ff
sta {z1}+3

