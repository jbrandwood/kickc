// Minimal struct - accessing pointer to struct in memory using arrow operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    lda $1000
    sta SCREEN
    lda $1000+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    lda $1000+SIZEOF_STRUCT_POINT
    sta SCREEN+2
    lda $1000+SIZEOF_STRUCT_POINT+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    rts
}
