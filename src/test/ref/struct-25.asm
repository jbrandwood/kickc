// Minimal struct with C-Standard behavior - member array sizeof
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 4
main: {
    // SCREEN[0] = sizeof(struct Point)
    lda #SIZEOF_STRUCT_POINT
    sta SCREEN
    // }
    rts
}
