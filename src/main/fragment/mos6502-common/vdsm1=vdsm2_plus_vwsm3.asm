lda {m3}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
clc
lda {m2}
adc {m3}
sta {m1}
lda {m2}+1
adc {m3}+1
sta {m1}+1
lda {m2}+2
adc $ff
sta {m1}+2
lda {m2}+3
adc $ff
sta {m1}+3