// Minimal struct - array of struct - far pointer math indexing
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFS_X = 0
  .const OFFS_Y = 1
main: {
    .label SCREEN = $400
    .label _1 = 4
    .label _3 = 2
    .label _8 = 4
    .label _11 = 2
    .label point_i = 2
    .label point_i1 = 2
    ldx #0
  b1:
    txa
    asl
    clc
    adc #<points
    sta point_i
    lda #>points
    adc #0
    sta point_i+1
    lda point_i
    sta _1
    lda point_i+1
    sta _1+1
    txa
    ldy #OFFS_X
    sta (_1),y
    txa
    clc
    adc #4
    // points[i].x = i;
    ldy #OFFS_Y
    sta (_3),y
    inx
    cpx #4
    bne b1
    ldx #0
  b2:
    txa
    asl
    clc
    adc #<points
    sta point_i1
    lda #>points
    adc #0
    sta point_i1+1
    lda point_i1
    sta _8
    lda point_i1+1
    sta _8+1
    ldy #OFFS_X
    lda (_8),y
    sta SCREEN,x
    // SCREEN[i] = points[i].x;
    ldy #OFFS_Y
    lda (_11),y
    sta SCREEN+$28,x
    inx
    cpx #4
    bne b2
    rts
}
  points: .fill 2*4, 0
