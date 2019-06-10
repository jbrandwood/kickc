// Minimal struct -  array of 3-byte structs (required *3)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_POINT_Z = 2
main: {
    .label SCREEN = $400
    .label _2 = 2
    ldx #0
  b1:
    txa
    eor #$ff
    clc
    adc #1
    sta _2
    txa
    asl
    stx $ff
    clc
    adc $ff
    tay
    txa
    sta points,y
    lda _2
    sta points+OFFSET_STRUCT_POINT_Y,y
    txa
    sta points+OFFSET_STRUCT_POINT_Z,y
    inx
    cpx #4
    bne b1
    ldx #0
  b2:
    txa
    asl
    stx $ff
    clc
    adc $ff
    tay
    lda points,y
    sta SCREEN,y
    lda points+OFFSET_STRUCT_POINT_Y,y
    sta SCREEN+OFFSET_STRUCT_POINT_Y,y
    lda points+OFFSET_STRUCT_POINT_Z,y
    sta SCREEN+OFFSET_STRUCT_POINT_Z,y
    inx
    cpx #4
    bne b2
    rts
}
  points: .fill 3*4, 0
