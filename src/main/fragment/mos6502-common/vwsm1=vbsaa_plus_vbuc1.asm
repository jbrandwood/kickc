sta {m1}
// sign-extend the byte
ora #$7f
bmi !+
lda #0
!:
sta {m1}+1
// add the constant
lda {m1}
clc
adc #{c1}
sta {m1}
lda {m1}+1
adc #0
sta {m1}+1
