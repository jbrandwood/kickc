// ROL twice instead of RORing 6 times
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
rol {z1}+1 // 64


lda {z2}
asl
sta {z1}
lda {z2}+1
rol
sta {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1
asl {z1}
rol {z1}+1 // 66