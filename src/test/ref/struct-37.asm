// Complex C-struct - copying a sub-struct from C-standard layout to Unwound layout
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const MOVE_TO = 0
  .const SPLINE_TO = 1
  .label SCREEN = $400
  .const OFFSET_STRUCT_SEGMENT_TO = 1
  .const OFFSET_STRUCT_SPLINEVECTOR16_Y = 1
main: {
    .label to_x = 3
    .label to_y = 4
    .label j = 2
    lda #0
    sta.z j
    tax
  __b1:
    txa
    asl
    asl
    stx.z $ff
    clc
    adc.z $ff
    tay
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO,y
    sta.z to_x
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y,y
    sta.z to_y
    lda.z to_x
    ldy.z j
    sta SCREEN,y
    iny
    lda.z to_y
    sta SCREEN,y
    iny
    sty.z j
    inx
    cpx #3
    bne __b1
    rts
}
  // True type letter c
  letter_c: .byte MOVE_TO, 'a', 'b', 0, 0, SPLINE_TO, 'c', 'd', $67, $a9, SPLINE_TO, 'e', 'f', $4b, $c3
