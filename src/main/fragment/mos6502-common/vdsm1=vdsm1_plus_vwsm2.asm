lda {m2}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
lda {m1}
clc
adc {m2}
sta {m1}
lda {m1}+1
adc {m2}+1
sta {m1}+1
lda {m1}+2
adc $ff
sta {m1}+2
lda {m1}+3
adc $ff
sta {m1}+3

