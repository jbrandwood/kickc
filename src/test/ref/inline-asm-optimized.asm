// Tests that inline assembler is optimized
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // *SCREEN = 0
    lda #0
    sta SCREEN
    // asm
    sta SCREEN+1
    sta SCREEN+2
    // SCREEN[3] = 0
    sta SCREEN+3
    // asm
    sta SCREEN+4
    // }
    rts
}
