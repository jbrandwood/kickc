// Minimal struct - accessing pointer to struct in memory
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    // SCREEN[0] = (*points).x
    lda $1000
    sta SCREEN
    // SCREEN[1] = (*points).y
    lda $1000+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // SCREEN[2] = (*points).x
    lda $1000+SIZEOF_STRUCT_POINT
    sta SCREEN+2
    // SCREEN[3] = (*points).y
    lda $1000+SIZEOF_STRUCT_POINT+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    // }
    rts
}
