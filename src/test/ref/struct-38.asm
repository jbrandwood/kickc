// Complex C-struct - copying a sub-struct with 2-byte members from C-standard layout to Unwound layout
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const MOVE_TO = 0
  .const SPLINE_TO = 1
  .label SCREEN = $400
  .const OFFSET_STRUCT_SEGMENT_TO = 1
  .const OFFSET_STRUCT_SPLINEVECTOR16_Y = 2
main: {
    .label to_x = 3
    .label to_y = 5
    .label j = 2
    lda #0
    sta.z j
    tax
  __b1:
    // to = letter_c[i].to
    txa
    asl
    asl
    asl
    stx.z $ff
    clc
    adc.z $ff
    tay
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO,y
    sta.z to_x
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+1,y
    sta.z to_x+1
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y,y
    sta.z to_y
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,y
    sta.z to_y+1
    // SCREEN[j++] = to.x
    lda.z j
    asl
    tay
    lda.z to_x
    sta SCREEN,y
    lda.z to_x+1
    sta SCREEN+1,y
    // SCREEN[j++] = to.x;
    inc.z j
    // SCREEN[j++] = to.y
    lda.z j
    asl
    tay
    lda.z to_y
    sta SCREEN,y
    lda.z to_y+1
    sta SCREEN+1,y
    // SCREEN[j++] = to.y;
    inc.z j
    // for( byte i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
}
  // True type letter c
  letter_c: .byte MOVE_TO
  .word 'a', 'b', 0, 0
  .byte SPLINE_TO
  .word 'c', 'd', $67, $a9
  .byte SPLINE_TO
  .word 'e', 'f', $4b, $c3
