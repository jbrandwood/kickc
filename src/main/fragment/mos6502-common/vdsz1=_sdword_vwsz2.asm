// sign-extend the byte
lda {z2}
sta {z1}
lda {z2}+1
sta {z1}+1
ora #$7f
bmi !+
lda #0
!:
sta {z1}+2
sta {z1}+3
