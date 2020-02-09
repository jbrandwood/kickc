// Complex C-struct - copying a sub-struct with 2-byte members from C-standard layout to C-standard layout (expecting a memcpy)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const MOVE_TO = 0
  .const SPLINE_TO = 1
  .label SCREEN = $400
  .const OFFSET_STRUCT_SEGMENT_TO = 1
  .const SIZEOF_STRUCT_VECTOR = 4
  .const OFFSET_STRUCT_VECTOR_Y = 2
main: {
    .label to = 4
    .label j = 3
    .label i = 2
    lda #0
    sta.z j
    sta.z i
  __b1:
    lda.z i
    asl
    asl
    asl
    clc
    adc.z i
    tax
    ldy #0
  !:
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO,x
    sta to,y
    inx
    iny
    cpy #SIZEOF_STRUCT_VECTOR
    bne !-
    lda.z j
    asl
    tay
    lda.z to
    sta SCREEN,y
    lda.z to+1
    sta SCREEN+1,y
    ldx.z j
    inx
    txa
    asl
    tay
    lda to+OFFSET_STRUCT_VECTOR_Y
    sta SCREEN,y
    lda to+OFFSET_STRUCT_VECTOR_Y+1
    sta SCREEN+1,y
    inx
    stx.z j
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    rts
}
  // True type letter c
  letter_c: .byte MOVE_TO
  .word 'a', 'b', 0, 0
  .byte SPLINE_TO
  .word 'c', 'd', $67, $a9
  .byte SPLINE_TO
  .word 'e', 'f', $4b, $c3
