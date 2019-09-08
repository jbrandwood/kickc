sta {z1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {z1}+1