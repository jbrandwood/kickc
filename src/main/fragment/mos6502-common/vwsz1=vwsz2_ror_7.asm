// ROL once instead of RORing 7 times
lda {z2}   // {z2} low byte to tmp $ff
sta $ff
lda {z2}+1 // {z2} high byte to {z1} low byte
sta {z1}
lda #0
bit {z2}+1
bpl !+     // {z2} high byte positive?
lda #$ff
!:
sta {z1}+1 // sign extended {z2} into {z1} high byte
// ROL once
rol $ff
rol {z1}
rol {z1}+1
