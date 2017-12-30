sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
sec
lda {z1}
sbc $fe
sta {z1}
lda {z1}+1
sbc $ff
sta {z1}+1
