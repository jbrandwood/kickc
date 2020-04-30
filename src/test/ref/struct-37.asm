// Complex C-struct - copying a sub-struct from C-standard layout to Unwound layout
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const MOVE_TO = 0
  .const SPLINE_TO = 1
  .const OFFSET_STRUCT_SEGMENT_TO = 1
  .const OFFSET_STRUCT_SPLINEVECTOR16_Y = 1
  .label SCREEN = $400
main: {
    .label to_x = 3
    .label to_y = 4
    .label j = 2
    lda #0
    sta.z j
    tax
  __b1:
    // to = letter_c[i].to
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
    // SCREEN[j++] = to.x
    lda.z to_x
    ldy.z j
    sta SCREEN,y
    // SCREEN[j++] = to.x;
    iny
    // SCREEN[j++] = to.y
    lda.z to_y
    sta SCREEN,y
    // SCREEN[j++] = to.y;
    iny
    sty.z j
    // for( byte i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
}
  // True type letter c
  letter_c: .byte MOVE_TO, 'a', 'b', 0, 0, SPLINE_TO, 'c', 'd', $67, $a9, SPLINE_TO, 'e', 'f', $4b, $c3
