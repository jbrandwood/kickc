// sign-extend the byte
lda {m2}
sta {m1}
lda {m2}+1
sta {m1}+1
ora #$7f
bmi !+
lda #0
!:
sta {m1}+2
sta {m1}+3
