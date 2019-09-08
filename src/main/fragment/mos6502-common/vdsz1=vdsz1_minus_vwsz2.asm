lda {z2}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
sec
lda {z1}
sbc {z2}
sta {z1}
lda {z1}+1
sbc {z2}+1
sta {z1}+1
lda {z1}+2
sbc $ff
sta {z1}+2
lda {z1}+3
sbc $ff
sta {z1}+3
