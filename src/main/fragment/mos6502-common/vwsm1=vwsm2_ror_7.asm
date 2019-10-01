// ROL once instead of RORing 7 times
lda {m2}   // {m2} low byte to tmp $ff
sta $ff
lda {m2}+1 // {m2} high byte to {m1} low byte
sta {m1}
lda #0
bit {m2}+1
bpl !+     // {m2} high byte positive?
lda #$ff
!:
sta {m1}+1 // sign extended {m2} into {m1} high byte
// ROL once
rol $ff
rol {m1}
rol {m1}+1
