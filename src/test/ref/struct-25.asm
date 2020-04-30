// Minimal struct with C-Standard behavior - member array sizeof
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 4
  .label SCREEN = $400
main: {
    // SCREEN[0] = sizeof(struct Point)
    lda #SIZEOF_STRUCT_POINT
    sta SCREEN
    // }
    rts
}
