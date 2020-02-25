// Tests the sizeof() operator on structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const SIZEOF_STRUCT_CIRCLE = 3
main: {
    // Struct Arrays
    .const NUM_POINTS = 4
    .const NUM_CIRCLES = NUM_POINTS-1
    // SCREEN[idx++] = '0'+sizeof(struct Point)
    // Struct Types
    lda #'0'+SIZEOF_STRUCT_POINT
    sta SCREEN
    // SCREEN[idx++] = '0'+sizeof(struct Circle)
    lda #'0'+SIZEOF_STRUCT_CIRCLE
    sta SCREEN+1
    // SCREEN[idx++] = '0'+sizeof(p)
    lda #'0'+SIZEOF_STRUCT_POINT
    sta SCREEN+3
    // SCREEN[idx++] = '0'+sizeof(c)
    lda #'0'+SIZEOF_STRUCT_CIRCLE
    sta SCREEN+4
    // SCREEN[idx++] = '0'+sizeof(points)
    lda #'0'+NUM_POINTS*SIZEOF_STRUCT_POINT
    sta SCREEN+6
    // SCREEN[idx++] = '0'+sizeof(points)/sizeof(struct Point)
    lda #'0'+NUM_POINTS*SIZEOF_STRUCT_POINT/SIZEOF_STRUCT_POINT
    sta SCREEN+7
    // SCREEN[idx++] = '0'+sizeof(circles)
    lda #'0'+NUM_CIRCLES*SIZEOF_STRUCT_CIRCLE
    sta SCREEN+8
    // SCREEN[idx++] = '0'+sizeof(circles)/sizeof(struct Circle)
    lda #'0'+NUM_CIRCLES*SIZEOF_STRUCT_CIRCLE/SIZEOF_STRUCT_CIRCLE
    sta SCREEN+9
    // }
    rts
}
