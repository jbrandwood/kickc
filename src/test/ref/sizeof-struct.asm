// Tests the sizeof() operator on structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const SIZEOF_STRUCT_CIRCLE = 3
  .label SCREEN = $400
main: {
    // Struct Array
    .const NUM_POINTS = 4
    .const NUM_CIRCLES = NUM_POINTS-1
    // Struct Types
    lda #'0'+SIZEOF_STRUCT_POINT
    sta SCREEN
    lda #'0'+SIZEOF_STRUCT_CIRCLE
    sta SCREEN+1
    lda #'0'+SIZEOF_STRUCT_POINT
    sta SCREEN+3
    lda #'0'+SIZEOF_STRUCT_CIRCLE
    sta SCREEN+4
    lda #'0'+NUM_POINTS*SIZEOF_STRUCT_POINT
    sta SCREEN+6
    lda #'0'+NUM_CIRCLES*SIZEOF_STRUCT_POINT
    sta SCREEN+7
    rts
}
