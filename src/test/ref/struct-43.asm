// Minimal struct with C-Standard behavior - struct with internal int array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  .const OFFSET_STRUCT_POINT_ID = 5
  .const OFFSET_STRUCT_POINT_POS = 1
  .label SCREEN = $400
main: {
    // SCREEN[0] = point1.id
    lda point1+OFFSET_STRUCT_POINT_ID
    sta SCREEN
    lda point1+OFFSET_STRUCT_POINT_ID+1
    sta SCREEN+1
    // SCREEN[1] = point1.pos[0]
    lda point1+OFFSET_STRUCT_POINT_POS
    sta SCREEN+1*SIZEOF_WORD
    lda point1+OFFSET_STRUCT_POINT_POS+1
    sta SCREEN+1*SIZEOF_WORD+1
    // SCREEN[2] = point1.pos[1]
    lda point1+OFFSET_STRUCT_POINT_POS+1*SIZEOF_WORD
    sta SCREEN+2*SIZEOF_WORD
    lda point1+OFFSET_STRUCT_POINT_POS+1*SIZEOF_WORD+1
    sta SCREEN+2*SIZEOF_WORD+1
    // }
    rts
}
  point1: .byte 4
  .word 1, 2, 3
