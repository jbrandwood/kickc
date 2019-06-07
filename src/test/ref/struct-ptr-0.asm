// Minimal struct - array of struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label _5 = 2
    ldx #0
  b1:
    txa
    asl
    sta _5
    tay
    txa
    sta points,y
    txa
    tay
    iny
    tya
    ldy _5
    sta points+1,y
    inx
    cpx #5
    bne b1
    ldy #0
  b2:
    tya
    asl
    tax
    lda points,x
    sta SCREEN,y
    lda points+1,x
    sta SCREEN+$28,y
    iny
    cpy #5
    bne b2
    rts
}
  points: .fill 2*4, 0
