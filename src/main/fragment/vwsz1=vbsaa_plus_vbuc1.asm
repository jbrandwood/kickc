sta {z1}
// sign-extend the byte
ora #$7f
bmi !+
lda #0
!:
sta {z1}+1
// add the constant
lda {z1}
clc
adc #{c1}
sta {z1}
lda {z1}+1
adc #0
sta {z1}+1
