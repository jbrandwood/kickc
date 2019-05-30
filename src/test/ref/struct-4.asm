// Minimal struct - array of struct - near pointer math indexing
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFS_Y = 1
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    txa
    asl
    tay
    txa
    sta points,y
    txa
    clc
    adc #4
    // points[i].x = i;
    sta points+OFFS_Y,y
    inx
    cpx #4
    bne b1
    ldy #0
  b2:
    tya
    asl
    tax
    lda points,x
    sta SCREEN,y
    // SCREEN[i] = points[i].x;
    lda points+OFFS_Y,x
    sta SCREEN+$28,y
    iny
    cpy #4
    bne b2
    rts
}
  points: .fill 2*4, 0
