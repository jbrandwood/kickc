lda {z1}
sta $ff
lda {z1}+1
sta {z1}
lda #0
bit {z1}+1
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