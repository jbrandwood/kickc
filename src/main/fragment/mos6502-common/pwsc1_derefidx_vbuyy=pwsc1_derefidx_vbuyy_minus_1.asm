sec
lda {c1},y
sbc #$01
sta {c1},y
lda {c1}+1,y
sbc #$00
sta {c1}+1,y