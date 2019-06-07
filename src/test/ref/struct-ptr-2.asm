// Minimal struct - array of struct - far pointer math indexing
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFS_Y = 1
main: {
    .label SCREEN = $400
    .label point_i = 2
    .label point_i1 = 4
    ldx #0
  b1:
    txa
    asl
    tay
    tya
    clc
    adc #<points
    sta point_i
    lda #>points
    adc #0
    sta point_i+1
    txa
    sta points,y
    txa
    clc
    adc #4
    // points[i].x = i;
    ldy #OFFS_Y
    sta (point_i),y
    inx
    cpx #4
    bne b1
    ldx #0
  b2:
    txa
    asl
    tay
    tya
    clc
    adc #<points
    sta point_i1
    lda #>points
    adc #0
    sta point_i1+1
    lda points,y
    sta SCREEN,x
    // SCREEN[i] = points[i].x;
    ldy #OFFS_Y
    lda (point_i1),y
    sta SCREEN+$28,x
    inx
    cpx #4
    bne b2
    rts
}
  points: .fill 2*4, 0
