lda {z2}
sta $ff
lda {z2}+1
sta {z1}
lda #0
bit {z2}+1
bpl !+
lda #$ff
!:
sta {z1}+1
rol $ff
rol {z1}
rol {z1}+1
rol $ff
rol {z1}
rol {z1}+1